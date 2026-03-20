import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  /// Fetches the user's notifications.
  /// [isRead] can be provided to filter read/unread notifications.
  Future<List<NotificationEntity>> getNotifications({bool? isRead});

  /// Marks a specific notification as read.
  Future<NotificationEntity> markAsRead(String id);

  /// Marks all unread notifications as read.
  Future<bool> markAllAsRead();
}
