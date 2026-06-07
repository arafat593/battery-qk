import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:batteryqk_web_app/data/services/utility/urls.dart';
import 'package:batteryqk_web_app/features/authentication/models/user_model.dart';
import '../../features/authentication/controllers/auth_controller.dart';
import '../../features/authentication/controllers/language_controller.dart';

class UserService {
  static Future<List<UserModel>> getAllUser() async {
    final String? token = await AuthController.getToken();
    
    final LanguageController languageController =
        Get.find<LanguageController>();
    final String acceptLanguage = languageController.currentLanguage;

    if (token == null || token.isEmpty) {
      throw Exception('Token is not available');
    }

    final url = Uri.parse(Urls.getAllUser);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (acceptLanguage.isNotEmpty) 'Accept-Language': acceptLanguage,
      },
    );

    // print("HTTP Response Code: ${response.statusCode}");
    // print("Raw response body: ${response.body}");

    try {
      final decoded = jsonDecode(response.body);

      // Case 1: List of users
      if (decoded is Map<String, dynamic> &&
          decoded.containsKey('data') &&
          decoded['data'] is List) {
        final List<dynamic> usersData = decoded['data'];
        return usersData.map((e) => UserModel.fromJson(e)).toList();
      }
      // Case 2: Only one user returned as Map
      else if (decoded is Map<String, dynamic> && decoded.containsKey('id')) {
        return [UserModel.fromJson(decoded)]; // wrap single user into list
      }
      // Case 3: Already a List
      else if (decoded is List) {
        return decoded.map((e) => UserModel.fromJson(e)).toList();
      }

      throw Exception('Unexpected API response structure. Response: $decoded');
    } catch (e) {
      print("Error decoding response: $e");
      throw Exception('Error parsing user data: $e');
    }
  }
}
