import 'dart:convert';

import 'package:batteryqk_web_app/data/services/utility/urls.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../features/authentication/controllers/auth_controller.dart';
import '../../features/authentication/controllers/language_controller.dart';
import '../../features/authentication/models/notification/notification_data_model.dart';

class NotificationService {
  static Future<NotificationData?> getNotification() async {
    final String? token = await AuthController.getToken();

    final LanguageController languageController =
        Get.find<LanguageController>();
    final String acceptLanguage = languageController.currentLanguage;
    if (token == null || token.isEmpty) {
      throw Exception('Token is not available');
    }

    final url = Uri.parse(Urls.usersNotification);

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-type": "application/json",
          if (acceptLanguage.isNotEmpty) 'Accept-Language': acceptLanguage,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return NotificationData.fromJson(data['data']);
      } else {
        print('Failed to fetch notifications. Code: ${response.statusCode}');
        return null;
      }
    } catch (e, s) {
      print("Exception: $e $s");
      return null;
    }
  }
}
