import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.notificationType,
    required super.level,
    required super.isRead,
    required super.isNew,
    required super.createdAt,
    super.readAt,
    super.expiresAt,
    required super.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'بدون عنوان',
      message: json['message'] as String? ?? '',
      notificationType: json['notification_type'] as String? ?? 'info',
      level: json['level'] as String? ?? 'info',
      isRead: json['is_read'] as bool? ?? false,
      isNew: json['is_new'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'notification_type': notificationType,
      'level': level,
      'is_read': isRead,
      'is_new': isNew,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'data': data,
    };
  }
}
