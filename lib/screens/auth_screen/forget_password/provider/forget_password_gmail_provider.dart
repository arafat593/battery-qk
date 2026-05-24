import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../services/repository/auth_repository.dart';
import '../../../../utils/app_log.dart';

final forgetPasswordGmailProvider =
    StateNotifierProvider<ForgetPasswordGmailProvider, bool>((ref) {
      return ForgetPasswordGmailProvider();
    });

class ForgetPasswordGmailProvider extends StateNotifier<bool> {
  ForgetPasswordGmailProvider() : super(false);

  /// SEND OTP
  Future<String> sendOtp(String email) async {
    try {
      state = true;

      final token = await AuthRepository.instance.forgotPassword(email: email);

      state = false;
      return token;
    } catch (e) {
      errorLog("sendOtp", e);
      state = false;
      return "";
    }
  }

  /// VERIFY OTP
  Future<bool> verifyOtp({
    required String email,
    required String token,
    required int otp,
  }) async {
    try {
      state = true;

      final result = await AuthRepository.instance.forgotVerifyEmail(
        email: email,
        token: token,
        otp: otp.toString(),
      );

      state = false;

      return result; // must be bool
    } catch (e) {
      errorLog("verifyOtp", e);
      state = false;
      return false;
    }
  }
}
