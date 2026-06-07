import 'package:flutter/foundation.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;

  static final String domain = _getDomain();
  static final String socket = _getDomain();

  // Reverb WebSocket Configurations
  static String reverbKey = const String.fromEnvironment('REVERB_APP_KEY', defaultValue: '487bdf0322617ae35986');
  static String reverbHost = const String.fromEnvironment('REVERB_HOST', defaultValue: 'olabisiolai.maktechlaravel.cloud');
  static int? reverbPort = int.tryParse(const String.fromEnvironment('REVERB_PORT', defaultValue: '443')) ?? 443;
  static String reverbScheme = const String.fromEnvironment('REVERB_SCHEME', defaultValue: 'wss');

  final String baseUrl = "$domain/api/v1"; 

  String refreshToken = "/refreshToken";
  String userProfile = "/user/profile";
  String about = "/about";
  String privacyPolicy = "/privacy-policy";
  String termsAndConditions = "/terms";
  String userReviews = "/user/reviews";
  String faq = "/faq";
  String notification = "/notification";

  String login = "/auth/login";
  String register = "/auth/register";
  String authOtpVerify = "/auth/otp/verify";
  String userResendOtp = "/auth/resend-otp";
  String googleLogin = "/auth/google/login";
  String appleLogin = "/auth/apple/login";

  String authForgotPassword = "/auth/forgot-password";
  String authForgotResendOtp = "/auth/forgot-password/resend-otp";
  String authVerifyEmail = "/auth/forgot-password/verify-otp";
  String authResetPassword = "/auth/reset-password";
  String logOut = "/auth/logout";

  String authDeleteAccount = "/authDeleteAccount";
  String user = "/user";
  String changePassword = "/changePassword";
  String userSettings = "/user/settings";
  String userFavorites = "/user/favorites";
  String userFavoritesToggle = "/user/favorites/toggle";

  String businessesHome = "/businesses/home";
  String businesses = "/businesses";
  String reviews = "/reviews";
  String reviewStore = "/reviews/store";
  String categories = "/categories";

  String conversations = "/conversations";
} 
  
String _getDomain() {
  const String liveServer = "https://api.gidira.tech";

  try {
    if (kDebugMode) {
      // return localServer;
    }
  } catch (e) {
    errorLog("_getDomain", e);
  }

  return liveServer;
}
 