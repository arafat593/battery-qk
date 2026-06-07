import 'package:batteryqk_web_app/common/widgets/custom_app_bar.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<NotificationController>(); // Accessing the controller

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(isBack: true, showNotification: false),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              // Using Obx to reactively rebuild the UI when the data in the controller changes
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.userNotification.isEmpty) {
                return Center(
                  child: Text('no_notifications'.tr),
                ); // Show no notifications message
              }

              return RefreshIndicator(
                onRefresh:
                    controller.fetchNotifications, // Refresh notifications
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.userNotification.length,
                  itemBuilder: (context, index) {
                    final notif = controller.userNotification[index];
                    return Card(
                      color:
                          notif.isRead
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : Colors.grey.shade100,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: AppColor.blueColor,
                        ),
                        title: Text(notif.title),
                        subtitle: Text(notif.message),
                        // trailing: notif.isRead
                        //     ? null
                        //     : const Icon(
                        //         Icons.circle,
                        //         size: 8,
                        //         color: Colors.red,
                        //       ),
                        onTap: () => controller.markAsRead(index),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
