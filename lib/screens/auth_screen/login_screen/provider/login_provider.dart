import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../services/repository/auth_repository.dart';
import '../../../../utils/app_log.dart';

final loginProvider =
StateNotifierProvider<LoginProvider, bool>((ref) {
  return LoginProvider();
});

class LoginProvider extends StateNotifier<bool> {
  LoginProvider() : super(false);

  Future<bool> signIn(String email, String password) async {
    try {
      state = true;

      final response = await AuthRepository.instance.login(
        email: email,
        password: password,
        fcmToken: '',
        deviceId: '',
      );

      state = false;
      return response;
    } catch (e) {
      errorLog("Login", e);
      state = false;
      return false;
    }
  }
}