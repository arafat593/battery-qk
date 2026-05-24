import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/services/api/non_auth_api.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:olabisiolai_flutter_app/services/repository/auth_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppApi {
  final Dio _dio = Dio();
  AppApi._privateConstructor();
  static final AppApi _instance = AppApi._privateConstructor();
  static AppApi get instance => _instance;
  var storageServices = StorageServices.instance;
  final appRoutes = AppRoutes.instance;
  AppApi() {
    _dio.options.baseUrl = AppApiUrl.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 120);
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
    _dio.options.followRedirects = false;

    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiUrl.instance.baseUrl;
          options.contentType = 'application/json';
          options.headers["Accept"] = "application/json";

          String token = await storageServices.getToken();
          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options); // Continue request
        },
        onError: (error, handler) async {
          appLog("""

API error occurred:

Status code: ${error.response?.statusCode}

Error message: ${error.message}

""");

          try {
            if (error.response?.statusCode == 401 &&
                !error.requestOptions.path.contains("/auth/login")) {
              String token = await storageServices.getRefreshToken();
              if (token.isEmpty) {
                String currentToken = await storageServices.getToken();
                if (currentToken != "firebase_google_user") {
                  await storageServices.logout();
                  try {
                    await AuthRepository.instance.auth.signOut();
                    await AuthRepository.instance.googleSignIn.signOut();
                  } catch (_) {}
                  appRoutes.pushReplacement(AppRoutesKey.instance.splash);
                }
                return handler.next(error);
              }
              final newAccessToken = await reFreshNewAccessToken(token);
              if (newAccessToken.isNotEmpty) {
                _dio.options.headers["Authorization"] =
                    "Bearer $newAccessToken";
                return handler.resolve(await _dio.fetch(error.requestOptions));
              } else {
                String currentToken = await storageServices.getToken();
                if (currentToken != "firebase_google_user") {
                  await storageServices.logout();
                  try {
                    await AuthRepository.instance.auth.signOut();
                    await AuthRepository.instance.googleSignIn.signOut();
                  } catch (_) {}
                  appRoutes.pushReplacement(AppRoutesKey.instance.splash);
                }
                return handler.next(error);
              }
            }
          } catch (e) {
            errorLog("error form api try and catch bloc", e);
            return handler.next(error);
          }

          return handler.next(error); // Continue with error
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
    });
  }
  Dio get sendRequest => _dio;
}

// Token refresh logic
Future<String> reFreshNewAccessToken(String refreshToken) async {
  try {
    final response = await NonAuthApi().sendRequest.post(
      AppApiUrl.instance.refreshToken,
      data: {"token": refreshToken},
    );
    if (response.statusCode == 200) {
      if (response.data["data"] != null && response.data["data"] is Map) {
        var data = response.data["data"];
        if (data["accessToken"] != null && data["accessToken"] is String) {
          await StorageServices.instance.setToken(data["accessToken"]);
          return data["accessToken"].toString();
        }
      }
    } else {
      await StorageServices.instance.logout();
      try {
        await AuthRepository.instance.auth.signOut();
        await AuthRepository.instance.googleSignIn.signOut();
      } catch (_) {}
    }
  } catch (e) {
    errorLog("reFreshNewAccessToken", e);
  }
  return "";
}
