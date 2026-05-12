import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/error_handling_screen/not_found_screen.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/routes/internet_check_provider.dart';
import 'package:olabisiolai_flutter_app/screens/splash_screen/splash_screen.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:go_router/go_router.dart';
import '../screens/account_settings_screen/account_settings_screen.dart';
import '../screens/app_navigation_screen/app_navigation_screen.dart';
import '../screens/auth_screen/forget_password/forget_password_gmail/forget_password_gmail.dart';
import '../screens/auth_screen/forget_password/recover_password/recover_password.dart';
import '../screens/auth_screen/forget_password/successful_screen/successfull_screen.dart';
import '../screens/auth_screen/login_screen/login_screen.dart';
import '../screens/auth_screen/otp_verification_screen/otp_verification_screen.dart';
import '../screens/auth_screen/sign_up_screen/sign_up_screen.dart';
 import '../screens/base_screen/about_us_screen/about_us_screen.dart';
import '../screens/base_screen/privacy_policy_screen/privacy_policy_screen.dart';
import '../screens/base_screen/terms_and_conditions_screen/terms_and_conditions_screen.dart';
import '../screens/business_profile/business_profile.dart';
import '../screens/business_profile_photos_screen/business_profile_photos_screen.dart';
import '../screens/business_profile_review_screen/business_profile_review_screen.dart';
import '../screens/categories_screen/categories_screen.dart';
import '../screens/edit_profile_screen/edit_profile_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/map_screen/map_screen.dart';
import '../screens/message_details_screen/messages_details_screen.dart';
import '../screens/message_screen/message_screen.dart';
import '../screens/my_reviews_screen/my_reviews_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/review_submitted_screen/review_submitted_screen.dart';
import '../screens/saved_business_screen/saved_business_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  ////////////// constructor
  AppRoutes._privateConstructor();

  static final AppRoutes _instance = AppRoutes._privateConstructor();

  static AppRoutes get instance => _instance;

  //////////////// routes

  GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutesKey.instance.initial,
    routes: [
      GoRoute(
        path: AppRoutesKey.instance.initial,
        name: AppRoutesKey.instance.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.notFoundScreen}",
        name: AppRoutesKey.instance.noInternetScreen,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.loginScreen}",
        name: AppRoutesKey.instance.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.appNavigationScreen}",
        name: AppRoutesKey.instance.appNavigationScreen,
        builder: (context, state) => AppNavigationScreen(key: appNavigationKey),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.homeScreen}",
        name: AppRoutesKey.instance.homeScreen,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.categoriesScreen}",
        name: AppRoutesKey.instance.categoriesScreen,
        builder: (context, state) => CategoriesScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.messageScreen}",
        name: AppRoutesKey.instance.messageScreen,
        builder: (context, state) => MessageScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.profileScreen}",
        name: AppRoutesKey.instance.profileScreen,
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.mapScreen}",
        name: AppRoutesKey.instance.mapScreen,
        builder: (context, state) => MapScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.businessProfile}",
        name: AppRoutesKey.instance.businessProfile,
        builder: (context, state) => BusinessProfile(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.businessProfilePhotosScreen}",
        name: AppRoutesKey.instance.businessProfilePhotosScreen,
        builder: (context, state) => BusinessProfilePhotosScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.businessProfileReviewScreen}",
        name: AppRoutesKey.instance.businessProfileReviewScreen,
        builder: (context, state) => BusinessProfileReviewScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.reviewSubmittedScreen}",
        name: AppRoutesKey.instance.reviewSubmittedScreen,
        builder: (context, state) => ReviewSubmittedScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.messagesDetailsScreen}",
        name: AppRoutesKey.instance.messagesDetailsScreen,
        builder: (context, state) => MessagesDetailsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.editProfileScreen}",
        name: AppRoutesKey.instance.editProfileScreen,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.savedBusinessesScreen}",
        name: AppRoutesKey.instance.savedBusinessesScreen,
        builder: (context, state) => SavedBusinessesScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.myReviewsScreen}",
        name: AppRoutesKey.instance.myReviewsScreen,
        builder: (context, state) => MyReviewsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.accountSettingsScreen}",
        name: AppRoutesKey.instance.accountSettingsScreen,
        builder: (context, state) => AccountSettingsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.aboutUsScreen}",
        name: AppRoutesKey.instance.aboutUsScreen,
        builder: (context, state) => AboutUsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.privacyPolicyScreen}",
        name: AppRoutesKey.instance.privacyPolicyScreen,
        builder: (context, state) => PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.termsAndConditionsScreen}",
        name: AppRoutesKey.instance.termsAndConditionsScreen,
        builder: (context, state) => TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.signUpScreen}",
        name: AppRoutesKey.instance.signUpScreen,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.forgetPassword}",
        name: AppRoutesKey.instance.forgetPassword,
        builder: (context, state) => ForgetPasswordGmail(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.recoverPassword}",
        name: AppRoutesKey.instance.recoverPassword,
        builder: (context, state) => RecoverPassword(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.successfullScreen}",
        name: AppRoutesKey.instance.successfullScreen,
        builder: (context, state) => SuccessFullScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.otpVerificationScreen}",
        name: AppRoutesKey.instance.otpVerificationScreen,
        builder: (context, state) => OtpVerificationScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return NotFoundScreen();
    },
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final asyncStatus = container.read(internetStatusProvider);

      if (asyncStatus.isLoading) return null;
      if (asyncStatus.hasError) return "/${AppRoutesKey.instance.errorScreen}";

      final isOnline = asyncStatus.value ?? true;
      final goingToNoInternet =
          state.name == AppRoutesKey.instance.noInternetScreen;

      if (!isOnline && !goingToNoInternet) {
        return "/${AppRoutesKey.instance.noInternetScreen}";
      }

      if (isOnline && goingToNoInternet) {
        return "/"; // initial route
      }

      return null;
    },
  );

  ////////////////////. route operation start
  String _normalize(String value) => value.startsWith("/") ? value : "/$value";

  void go(String value) {
    try {
      router.go(_normalize(value));
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void goNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) {
    try {
      router.goNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        fragment: fragment,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void replace(String value, {Object? extra}) {
    try {
      router.replace(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void replaceNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.replaceNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void push(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.push(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("push", e);
    }
  }

  void pushNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("pushNamed", e);
    }
  }

  void pushReplacement(String value, {Map<String, String> pathParameters = const {}, Map<String, dynamic> queryParameters = const {}, Object? extra}) {
    try {
      router.pushReplacementNamed(
        value,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } catch (e) {
      errorLog("pushReplacement", e);
    }
  }

  void pushReplacementNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushReplacementNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("pushReplacementNamed", e);
    }
  }

  void pop() {
    try {
      GoRouter.of(rootNavigatorKey.currentContext!).pop();
    } catch (e) {
      errorLog("pop", e);
    }
  }

  ////////////////////. route operation end
}
