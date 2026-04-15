import 'notification_model.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsResponseModel {
  final int unreadCount;
  final List<NotificationModel> unread;
  final List<NotificationModel> today;
  final List<NotificationModel> thisWeek;
  final List<NotificationModel> older;

  const NotificationsResponseModel({
    required this.unreadCount,
    required this.unread,
    required this.today,
    required this.thisWeek,
    required this.older,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      unreadCount: json['unread_count'] as int? ?? 0,
      unread: (json['unread'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      today: (json['today'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      thisWeek: (json['this_week'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      older: (json['older'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
