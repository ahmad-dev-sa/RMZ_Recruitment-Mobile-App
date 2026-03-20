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
  final List<NotificationEntity> notifications;
  
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState({
    this.isLoading = false,
    this.error,
    this.notifications = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    String? error,
    List<NotificationEntity>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      notifications: notifications ?? this.notifications,
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
      final notifications = await _repository.getNotifications();
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final updatedNotification = await _repository.markAsRead(id);
      
      final updatedList = state.notifications.map<NotificationEntity>((n) {
        if (n.id == id) {
          return updatedNotification;
        }
        return n;
      }).toList();

      state = state.copyWith(notifications: updatedList);
    } catch (e) {
      // Could show a snackbar here, but for now we just fail silently or log
      print("Failed to mark notification as read: $e");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final success = await _repository.markAllAsRead();
      if (success) {
        final updatedList = state.notifications.map((n) {
          return NotificationEntity(
            id: n.id,
            title: n.title,
            message: n.message,
            notificationType: n.notificationType,
            level: n.level,
            isRead: true, // Optimistically force true or re-fetch
            createdAt: n.createdAt,
            data: n.data,
          );
        }).toList();
        state = state.copyWith(notifications: updatedList);
      }
    } catch (e) {
      print("Failed to mark all as read: $e");
    }
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repository);
});
