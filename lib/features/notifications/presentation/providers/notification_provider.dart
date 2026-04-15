import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repositories/notification_repository_impl.dart';

// --- Data Layer Providers ---
final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NotificationRemoteDataSourceImpl(dioClient);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
});

// --- State Providers ---

class NotificationState {
  final bool isLoading;
  final String? error;
  
  final int unreadCount;
  final List<NotificationEntity> unread;
  final List<NotificationEntity> today;
  final List<NotificationEntity> thisWeek;
  final List<NotificationEntity> older;

  NotificationState({
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
    this.unread = const [],
    this.today = const [],
    this.thisWeek = const [],
    this.older = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    int? unreadCount,
    List<NotificationEntity>? unread,
    List<NotificationEntity>? today,
    List<NotificationEntity>? thisWeek,
    List<NotificationEntity>? older,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      unreadCount: unreadCount ?? this.unreadCount,
      unread: unread ?? this.unread,
      today: today ?? this.today,
      thisWeek: thisWeek ?? this.thisWeek,
      older: older ?? this.older,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(NotificationState()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getNotifications();
      state = state.copyWith(
        isLoading: false,
        unreadCount: response.unreadCount,
        unread: response.unread,
        today: response.today,
        thisWeek: response.thisWeek,
        older: response.older,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    final target = state.unread.firstWhere((n) => n.id == id, orElse: () => state.unread.first);
    
    // Check if it's already read to avoid duplicating work
    if (!target.isNew && target.isRead) return;

    // Optimistically update
    final newUnread = state.unread.where((n) => n.id != id).toList();
    final updatedTarget = target.copyWith(isRead: true, isNew: false, readAt: DateTime.now());
    
    // Simplistic optimistic strategy: just prepend to 'today' since it was read today
    final newToday = [updatedTarget, ...state.today];

    state = state.copyWith(
      unread: newUnread,
      today: newToday,
      unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
    );

    try {
      await _repository.markAsRead(id);
    } catch (e) {
      // If error occurs, revert or reload. Easiest is to reload.
      fetchNotifications();
    }
  }

  Future<void> markAllAsRead() async {
    if (state.unread.isEmpty) return;

    // Optimistically move everything to today for UI snappiness
    final newToday = [...state.unread.map((n) => n.copyWith(isRead: true, isNew: false, readAt: DateTime.now())), ...state.today];
    
    state = state.copyWith(
      unread: [],
      today: newToday,
      unreadCount: 0,
    );

    try {
       await _repository.markAllAsRead();
    } catch (e) {
       fetchNotifications();
    }
  }

  Future<void> deleteNotification(String id) async {
    // Optimistically remove from any list
    state = state.copyWith(
      unread: state.unread.where((n) => n.id != id).toList(),
      today: state.today.where((n) => n.id != id).toList(),
      thisWeek: state.thisWeek.where((n) => n.id != id).toList(),
      older: state.older.where((n) => n.id != id).toList(),
      unreadCount: state.unread.any((n) => n.id == id) && state.unreadCount > 0 
          ? state.unreadCount - 1 
          : state.unreadCount,
    );

    try {
      await _repository.deleteNotification(id);
    } catch (e) {
      // Revert if failed
      fetchNotifications();
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repository);
});
