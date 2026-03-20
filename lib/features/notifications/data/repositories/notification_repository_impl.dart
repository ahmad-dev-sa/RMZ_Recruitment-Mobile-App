import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications({bool? isRead}) async {
    return await remoteDataSource.getNotifications(isRead: isRead);
  }

  @override
  Future<NotificationEntity> markAsRead(String id) async {
    return await remoteDataSource.markAsRead(id);
  }

  @override
  Future<bool> markAllAsRead() async {
    return await remoteDataSource.markAllAsRead();
  }
}
