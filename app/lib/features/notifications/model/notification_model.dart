class NotificationModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final String priority;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.priority,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      priority: json['priority'] ?? 'normal',
      isRead: json['status'] == 'read',
    );
  }
}
