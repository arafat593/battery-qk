import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/auth_repository.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

final signUpProvider = StateNotifierProvider<SignUpProvider, SignUpState>(
  (ref) => SignUpProvider(ref),
);

class SignUpState {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String role;
  final bool isLoading;

  const SignUpState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.role = 'user',
    this.isLoading = false,
  });

  SignUpState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? role,
    bool? isLoading,
  }) {
    return SignUpState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignUpProvider extends StateNotifier<SignUpState> {
  final Ref ref;

  SignUpProvider(this.ref) : super(const SignUpState());

  void update({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  Future<bool> signUp(GlobalKey<FormState> formKey) async {
    try {
      if (!formKey.currentState!.validate()) return false;

      state = state.copyWith(isLoading: true);

      final success = await AuthRepository.instance.signUp(
        firstName: state.firstName,
        lastName: state.lastName,
        email: state.email,
        mobileNumber: state.phone,
        password: state.password,
        role: "user",
      );

      state = state.copyWith(isLoading: false);

      if (success) {
        await StorageServices.instance.setEmail(state.email);
        return true;
      }

      return false;
    } catch (e) {
      errorLog("signup error", e);
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
