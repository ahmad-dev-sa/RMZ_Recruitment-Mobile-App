import '../../data/models/notifications_response_model.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  /// Fetches the user's categorized notifications.
  Future<NotificationsResponseModel> getNotifications();

  /// Marks a specific notification as read.
  Future<NotificationEntity> markAsRead(String id);

  /// Marks all unread notifications as read.
  Future<bool> markAllAsRead();

  /// Delete a notification logically.
  Future<bool> deleteNotification(String id);
}
