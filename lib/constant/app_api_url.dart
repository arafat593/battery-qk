import 'package:flutter/foundation.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;

  static final String domain = _getDomain();
  static final String socket = _getDomain();

  final String baseUrl = "$domain/api/v1";

  String refreshToken = "/refreshToken";
  String userProfile = "/user/profile";
  String about = "/rule/about";
  String privacyPolicy = "/rule/privacy-policy";
  String termsAndConditions = "/rule/terms-and-conditions";
  String faq = "/faq";
  String notification = "/notification";

  String login = "/auth/login";
  String register = "/auth/register";
  String authOtpVerify = "/auth/otp/verify";
  String userResendOtp = "/auth/resend-otp";

  String authForgotPassword = "/auth/forgot-password";
  String authForgotResendOtp = "/auth/forgot-password/resend-otp";
  String authVerifyEmail = "/auth/forgot-password/verify-otp";
  String authResetPassword = "/auth/reset-password";
  String logOut = "/auth/logout";

  String authDeleteAccount = "/authDeleteAccount";
  String user = "/user";
  String changePassword = "/changePassword";
}

String _getDomain() {
  const String liveServer = "https://olabisiolai.maktechlaravel.cloud";
  const String localServer = "http://10.10.7.8:6008";

  try {
    if (kDebugMode) {
      // return localServer;
    }
  } catch (e) {
    errorLog("_getDomain", e);
  }

  return liveServer;
}
