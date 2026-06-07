import 'package:batteryqk_web_app/features/authentication/models/notification/user_model.dart';

class UserNotification {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? link;
  final String entityId;
  final String entityType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  UserNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.link,
    required this.entityId,
    required this.entityType,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      link: json['link'],
      entityId: json['entityId'],
      entityType: json['entityType'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }

  @override
  String toString() {
    return 'UserNotification(id: $id, userId: $userId, title: $title, message: $message, type: $type, isRead: $isRead, link: $link, entityId: $entityId, entityType: $entityType, createdAt: $createdAt, updatedAt: $updatedAt, user: $user)';
  }
}
