import 'package:batteryqk_web_app/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:batteryqk_web_app/features/authentication/controllers/language_controller.dart';
import 'package:batteryqk_web_app/features/authentication/views/login_screen.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:batteryqk_web_app/util/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/build_listing_card_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/user_controller.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key, required this.initialSelection});

  final bool initialSelection;

  @override
  Widget build(BuildContext context) {
    // Access the LanguageController instance
    final LanguageController languageController =
        Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Image.asset(AppImages.logo),
              Spacer(),
              Text(
                initialSelection
                    ? 'choose_your_language'.tr
                    : 'change_your_language'.tr,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: AppColor.whiteColor,
                  child: ListTile(
                    title: Center(
                      child: Text('English'),
                    ), // Use the translation
                    onTap:
                        initialSelection
                            ? () {
                              print(
                                'entered as english and initial selection$initialSelection',
                              );
                              // Toggle the language to English
                              languageController.toggleLanguage(true);
                              // Get.find<BuildListingCardController>().refreshForLanguage();
                              // Get.find<NotificationController>().fetchNotifications();
                              // Get.find<UserController>().fetchUser();
                              // Navigate to the bottom navigation
                              Get.off(
                                () => LogInScreen(),
                                arguments: {'refresh': true},
                              );
                            }
                            : () {
                              print(
                                'entered as english and initial selection$initialSelection',
                              );
                              // Toggle the language to English
                              languageController.toggleLanguage(true);
                              Get.find<BuildListingCardController>()
                                  .refreshForLanguage();
                              Get.find<NotificationController>()
                                  .fetchNotifications();
                              Get.find<UserController>().fetchUser();
                              // Navigate to the bottom navigation
                              Get.off(
                                () => CustomBottomNavigationBar(),
                                arguments: {'refresh': true},
                              );
                            },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Arabic Language Option
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
                child: Card(
                  color: AppColor.whiteColor,
                  child: ListTile(
                    title: Center(child: Text("عربي")), // Use the translation
                    onTap:
                        initialSelection
                            ? () {
                              print(
                                'entered as arabic and initial selection$initialSelection',
                              );
                              // Toggle the language to Arabic
                              languageController.toggleLanguage(false);
                              // Get.find<BuildListingCardController>().refreshForLanguage();
                              // Get.find<NotificationController>().fetchNotifications();
                              // Get.find<UserController>().fetchUser();
                              // Navigate to the bottom navigation
                              Get.off(
                                () => LogInScreen(),
                                arguments: {'refresh': true},
                              );
                            }
                            : () {
                              print(
                                'entered as arabic and initial selection$initialSelection',
                              );
                              // Toggle the language to English
                              languageController.toggleLanguage(false);
                              Get.find<BuildListingCardController>()
                                  .refreshForLanguage();
                              Get.find<NotificationController>()
                                  .fetchNotifications();
                              Get.find<UserController>().fetchUser();
                              // Navigate to the bottom navigation
                              Get.off(
                                () => CustomBottomNavigationBar(),
                                arguments: {'refresh': true},
                              );
                            },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
