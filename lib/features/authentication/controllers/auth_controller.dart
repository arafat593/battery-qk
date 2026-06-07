import 'dart:async';
import 'dart:convert';
import 'package:batteryqk_web_app/features/authentication/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String? accessToken;
  static UserCreate? userData;

  static Future<void> saveUserData(UserCreate userData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userData", jsonEncode(userData.toJson()));
    AuthController.userData = userData;
  }
    
  static Future<UserCreate?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? result = sharedPreferences.getString("userData");
    if (result == null) {
      return null;
    }
    final user = UserCreate.fromJson(jsonDecode(result));
    AuthController.userData = user;
    return user;
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('Token', token);  // Save token under 'Token' key
    AuthController.accessToken = token;
  }

  static Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('Token');  // Retrieve token using the same key
  }

  static Future<bool> isUserLoggedIn() async {
    final result = await getToken();
    accessToken = result;

    bool loginState = result != null;

    if (loginState) {
      await getUserData();
    }

    return loginState;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
