import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../services/repository/auth_repository.dart';
import '../../../../utils/app_log.dart';

final recoverPasswordProvider =
    StateNotifierProvider<RecoverPasswordProvider, bool>((ref) {
      return RecoverPasswordProvider();
    });

class RecoverPasswordProvider extends StateNotifier<bool> {
  RecoverPasswordProvider() : super(false);

  Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      state = true;

      final response = await AuthRepository.instance.forgotResetPassword(
        token: token,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      state = false;
      return response;
    } catch (e) {
      errorLog("resetPassword", e);
      state = false;
      return false;
    }
  }
}
