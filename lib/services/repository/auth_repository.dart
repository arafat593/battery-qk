import 'dart:io';
import 'package:dio/dio.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/services/api/non_auth_api.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AuthRepository {
  ////////////// Contractures
  AuthRepository._privetContractures();

  static final AuthRepository _instance = AuthRepository._privetContractures();

  static AuthRepository get instance => _instance;

  /////////////// object
  ApiServices apiServices = ApiServices.instance;
  NonAuthApi nonAuthApi = NonAuthApi();
  AppApiUrl api = AppApiUrl.instance;
  StorageServices storageServices = StorageServices.instance;

  /////////////// function
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
    // required String fcmToken,
    // required String deviceId,
  }) async {
    try {
      Map<String, String> bodyData = {
        "email": email.trim().toLowerCase(),
        "password": password.trim(),
        'role': 'user',
        // "deviceId": deviceId.trim(),
        // "fcmToken": fcmToken.trim(),
      };

      var response = await apiServices.postServices(
        url: api.login,
        body: bodyData,
      );
      if (response != null) {
        // Store tokens if present
        if (response["data"] != null && response["data"] is Map) {
          var data = response["data"];
          if (data["role"] != null && data["role"] is String) {
            await storageServices.setAppRoll(data["role"].toString());
          }
          if (data["accessToken"] != null && data["accessToken"] is String) {
            await storageServices.setToken(data["accessToken"].toString());
          }
          if (data["refreshToken"] != null && data["refreshToken"] is String) {
            await storageServices.setRefreshToken(data["refreshToken"].toString());
          }
        }
        return response;
      }
    } catch (e) {
      errorLog("login function repo", e);
    }
    return null;
  }

  Future<bool> accountDelete({required String password}) async {
    try {
      Map<String, String> body = {"password": password};
      var response = await apiServices.deleteServices(
        url: api.authDeleteAccount,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("accountDelete AuthRepository", e);
    }
    return false;
  }

  Future<bool> updateProfile({
    required String profileImage,
    required Map<String, String> body,
  }) async {
    try {
      FormData formData = FormData.fromMap(body);
      if (profileImage.isNotEmpty) {
        final file = File(profileImage);
        if (await file.exists()) {
          String fileName = file.path.split('/').last;
          var mimeType = lookupMimeType(file.path);
          formData.files.add(
            MapEntry(
              "profile",
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType.parse(
                  mimeType ?? "application/octet-stream",
                ),
              ),
            ),
          );
        }
      }
      var response = await apiServices.patchServices(
        url: api.user,
        body: formData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("updateProfile repo", e);
    }
    return false;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Map<String, String> body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      var response = await apiServices.postServices(
        url: api.changePassword,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("changePassword repo", e);
    }
    return false;
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String password,
    required String role,
  }) async {
    try {
      FormData formBodyData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": mobileNumber,
        "password": password,
        "password_confirmation": password,
        "role": role,
      });

      var response = await apiServices.postServices(
        url: api.register,
        body: formBodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("signUp repo", e);
    }
    return false;
  }

  Future<bool> authResendOTP({required String email}) async {
    try {
      var response = await apiServices.postServices(
        url: api.userResendOtp,
        body: {"email": email},
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authResendOTP", e);
    }
    return false;
  }

  Future<bool> authOtpVerify({required String email, required int otp}) async {
    try {
      Map<String, dynamic> bodyData = {"email": email, "code": otp};
      var response = await apiServices.postServices(
        url: api.authOtpVerify,
        body: bodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authOtpVerify", e);
    }
    return false;
  }

  ////////// forgot
  Future<String> forgotPassword({required String email}) async {
    try {
      var response = await apiServices.postServices(
        url: "${api.baseUrl}${api.authForgotPassword}",
        body: {"email": email},
      );

      if (response == null) return "";

      final data = response["data"];

      print("FORGOT DATA: $data");

      if (data is Map<String, dynamic>) {
        final token =
            data["token"] ?? data["reset_token"] ?? data["Token"] ?? "";

        return token.toString();
      }

      if (data is String) {
        return data;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }

    return "";
  }

  Future<String> authForgotResendOtp({required String email}) async {
    try {
      var response = await apiServices.postServices(
        url: api.authForgotResendOtp,
        body: {"email": email},
      );

      if (response != null && response["data"] != null) {
        final data = response["data"];

        if (data["token"] != null) {
          return data["token"]; // 🔥 important
        }
      }
    } catch (e) {
      errorLog("authResendOTP", e);
    }

    return "";
  }

  Future<bool> forgotVerifyEmail({
    required String email,
    required String token,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "token": token,
        "code": otp,
      };

      var response = await apiServices.postServices(
        url: api.authVerifyEmail,
        body: bodyData,
      );

      if (response != null && response["success"] == true) {
        return true; // ✅ success
      }
    } catch (e) {
      errorLog("forgotVerifyEmail repo", e);
    }

    return false; // ❌ fail
  }

  Future<bool> forgotResetPassword({
    required String token,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await nonAuthApi.sendRequest.post(
        api.authResetPassword,
        data: {
          "token": token,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      errorLog("resetPassword repo", e);
    }

    return false;
  }
}
