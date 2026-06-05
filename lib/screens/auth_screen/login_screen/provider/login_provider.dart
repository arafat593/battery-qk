import 'package:flutter_riverpod/legacy.dart';
import '../../../../services/repository/auth_repository.dart';
import '../../../../utils/app_log.dart';

final loginProvider = StateNotifierProvider<LoginProvider, bool>((ref) {
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
      );

      state = false;
      return response != null;
    } catch (e) {
      errorLog("Login", e);
      state = false;
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      state = true;
      final user = await AuthRepository.instance.signInWithGoogle();
      state = false;
      return user != null;
    } catch (e) {
      errorLog("Google Sign In", e);
      state = false;
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      state = true;
      final user = await AuthRepository.instance.signInWithApple();
      state = false;
      return user != null;
    } catch (e) {
      errorLog("Apple Sign In", e);
      state = false;
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      state = true;
      final success = await AuthRepository.instance.logOut();
      state = false;
      return success;
    } catch (e) {
      errorLog("Logout Provider", e);
      state = false;
      return false;
    }
  }
}
