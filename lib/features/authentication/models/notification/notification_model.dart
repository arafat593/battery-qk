import 'notification_data_model.dart';

class NotificationModel {
  final bool success;
  final NotificationData data;
  final String message;

  NotificationModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'],
      data: NotificationData.fromJson(json['data']),
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'NotificationModel(success: $success, data: $data, message: $message)';
  }
}
