class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String notificationType;
  final String level;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.level,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });
}
