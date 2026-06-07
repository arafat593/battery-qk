import 'package:get/get.dart';
import '../../../data/services/notification_service.dart';
import '../models/notification/user_notification.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var userNotification = <UserNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }


  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final model = await NotificationService.getNotification();
      if (model != null && model.notifications.isNotEmpty) {
        userNotification.assignAll(model.notifications);
        print(" Notifications fetched: ${userNotification.length}");
      } else {
        print(" No notifications found or API returned null.");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  void markAllAsRead() {
    userNotification.value = userNotification.map((n) {
      return n;
    }).toList();
  }


  void markAsRead(int index) {
    final updated = userNotification[index];
    userNotification[index] = updated;
  }
}

