class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String notificationType;
  final String level;
  final bool isRead;
  final bool isNew;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? expiresAt;
  final Map<String, dynamic> data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.level,
    required this.isRead,
    required this.isNew,
    required this.createdAt,
    this.readAt,
    this.expiresAt,
    required this.data,
  });

  // Helper method for optimistic updates
  NotificationEntity copyWith({
    bool? isRead,
    bool? isNew,
    DateTime? readAt,
  }) {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      notificationType: notificationType,
      level: level,
      isRead: isRead ?? this.isRead,
      isNew: isNew ?? this.isNew,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt,
      data: data,
    );
  }
}
