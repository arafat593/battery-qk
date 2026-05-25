import 'package:flutter_riverpod/legacy.dart';
import '../../../../services/repository/auth_repository.dart';
import '../../../../utils/app_log.dart';

final otpVerificationProvider =
    StateNotifierProvider<OtpVerificationProvider, bool>((ref) {
      return OtpVerificationProvider();
    });

class OtpVerificationProvider extends StateNotifier<bool> {
  OtpVerificationProvider() : super(false);

  Future<bool> verifyOtp({required String email, required int otp}) async {
    try {
      state = true;

      final response = await AuthRepository.instance.authOtpVerify(
        email: email,
        otp: otp,
      );

      state = false;
      return response;
    } catch (e) {
      errorLog("verifyOtp register", e);
      state = false;
      return false;
    }
  }
}
