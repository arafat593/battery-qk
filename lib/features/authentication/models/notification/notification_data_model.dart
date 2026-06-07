import 'package:batteryqk_web_app/features/authentication/models/notification/pagination.dart';
import 'package:batteryqk_web_app/features/authentication/models/notification/user_notification.dart';

class NotificationData {
  final List<UserNotification> notifications;
  final Pagination pagination;
  final String source;

  NotificationData({
    required this.notifications,
    required this.pagination,
    required this.source,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: List<UserNotification>.from(
        json['notifications'].map((x) => UserNotification.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
      source: json['source'],
    );
  }

  @override
  String toString() {
    return 'NotificationData(notifications: $notifications, pagination: $pagination, source: $source)';
  }
}
