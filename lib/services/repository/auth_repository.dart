import 'dart:io';
import 'package:dio/dio.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/services/api/non_auth_api.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  FirebaseAuth auth = FirebaseAuth.instance;
  // Use GoogleSignIn.instance instead of creating a new instance
  GoogleSignIn googleSignIn = GoogleSignIn.instance;

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
          } else if (data["token"] != null && data["token"] is String) {
            print("DEBUG: Saving token: ${data["token"]}");
            await storageServices.setToken(data["token"].toString());
          }
          if (data["refreshToken"] != null && data["refreshToken"] is String) {
            await storageServices.setRefreshToken(data["refreshToken"].toString());
          }
          if (data["user"] != null && data["user"] is Map) {
            // Save full user data
            Map<String, String> userData = (data["user"] as Map).map((key, value) => MapEntry(key.toString(), value.toString()));
            await storageServices.setLogDedData(userData);
            
            // Save email specifically if available
            if (data["user"]["email"] != null) {
              await storageServices.setEmail(data["user"]["email"].toString());
            }
          }
        }
        return response;
      }
    } catch (e) {
      errorLog("login function repo", e);
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Ensure GoogleSignIn is initialized with the Web Client ID from google-services.json
      await googleSignIn.initialize(
        serverClientId: "233797822107-kcufq98hr6lc5g4teuik1scv9vf1oh2o.apps.googleusercontent.com",
      );

      // Trigger the authentication flow
      // authenticate() is the new method for v7.0.0+
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Note: In v7.0.0+, accessToken is separated from authentication.
      // If we need it, we should use authorizeScopes, but for Firebase 
      // often idToken is sufficient. However, GoogleAuthProvider.credential 
      // usually wants both or at least idToken.
      
      // Let's request scopes to get the accessToken if needed
      final authClient = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
      final String? accessToken = authClient.accessToken;
      final String? idToken = googleAuth.idToken;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Save dummy token and email to persist login state
        await storageServices.setToken("firebase_google_user");
        await storageServices.setEmail(userCredential.user!.email ?? "");
        
        // Save basic user info
        Map<String, String> userData = {
          "name": userCredential.user!.displayName ?? "",
          "email": userCredential.user!.email ?? "",
          "photo": userCredential.user!.photoURL ?? "",
          "id": userCredential.user!.uid,
        };
        await storageServices.setLogDedData(userData);
      }

      return userCredential.user;
    } catch (e) {
      errorLog("signInWithGoogle", e);
      return null;
    }
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
        if (response["data"] != null && response["data"] is Map) {
          var data = response["data"];
          if (data["token"] != null) {
            await storageServices.setToken(data["token"].toString());
            await storageServices.setEmail(email);
            
            Map<String, String> userData = {
               "first_name": firstName,
               "last_name": lastName,
               "name": "$firstName $lastName".trim(),
               "email": email,
               "phone": mobileNumber,
            };
            await storageServices.setLogDedData(userData);
          }
        }
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
  Future<bool> logOut() async {
    try {
      // 1. Check token to see if we should call backend logout
      String token = await storageServices.getToken();
      
      // Only call backend logout if we have a real backend token
      if (token.isNotEmpty && token != "firebase_google_user") {
        try {
          await apiServices.postServices(url: api.logOut, body: {});
        } catch (e) {
          errorLog("backend logOut", e);
        }
      }

      // 2. Firebase Sign-out
      await auth.signOut();

      // 3. Google Sign-out (to clear cached account)
      await googleSignIn.signOut();

      // 4. Clear local storage
      await storageServices.logout();

      return true;
    } catch (e) {
      errorLog("logOut AuthRepository", e);
      // Ensure we clear local storage even on error
      await storageServices.logout();
      return true; // Return true as we've at least cleared local state
    }
  }
}
