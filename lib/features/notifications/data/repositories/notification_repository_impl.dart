import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notifications_response_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NotificationsResponseModel> getNotifications() async {
    return await remoteDataSource.getNotifications();
  }

  @override
  Future<NotificationEntity> markAsRead(String id) async {
    return await remoteDataSource.markAsRead(id);
  }

  @override
  Future<bool> markAllAsRead() async {
    return await remoteDataSource.markAllAsRead();
  }

  @override
  Future<bool> deleteNotification(String id) async {
    return await remoteDataSource.deleteNotification(id);
  }
}
