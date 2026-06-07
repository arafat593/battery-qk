import 'package:batteryqk_web_app/app.dart';
import 'package:batteryqk_web_app/features/authentication/controllers/language_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/authentication/controllers/build_listing_card_controller.dart';
import 'features/authentication/controllers/notification_controller.dart';
import 'features/authentication/controllers/user_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!Get.isRegistered<LanguageController>()) {
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  }
  if (!Get.isRegistered<BuildListingCardController>()) {
    Get.lazyPut<BuildListingCardController>(
      () => BuildListingCardController(),//buildListingController
      fenix: true,
    );
  }
  if (!Get.isRegistered<NotificationController>()) {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
  }
  if (!Get.isRegistered<UserController>()) {
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
  }

  runApp(const App());
}
