import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/app_asserts_icons_path.dart';
import '../../../../routes/app_routes.dart';
import '../../../../routes/app_routes_key.dart';
import '../../../../utils/app_size.dart';
import '../../../../utils/app_snack_bar.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/app_image/app_image.dart';
import '../../../../widgets/buttons/app_button.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';
import '../../../../widgets/texts/app_text.dart';
import '../provider/recover_password_provider.dart';

class RecoverPassword extends ConsumerStatefulWidget {
  const RecoverPassword({super.key});

  @override
  ConsumerState<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends ConsumerState<RecoverPassword> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> formKey;

  String token = "";

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();

    /// GET TOKEN FROM PREVIOUS SCREEN
    Future.microtask(() {
      token = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    if (token.isEmpty) {
      AppSnackBar.instance.error("Invalid session. Try again.");
      return;
    }

    final success = await ref
        .read(recoverPasswordProvider.notifier)
        .resetPassword(
          token: token,
          newPassword: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );

    if (success) {
      AppRoutes.instance.go(AppRoutesKey.instance.successfullScreen);
    } else {
      AppSnackBar.instance.error("Failed to reset password");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(recoverPasswordProvider);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: AppSize.size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Gap(height: 100),

                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraNameLogo,
                    width: 116,
                  ),

                  Gap(height: 40),

                  AppText(
                    text: 'Recover Password',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),

                  Gap(height: 12),

                  AppText(
                    text: 'Set a new password for your account.',
                    textAlign: TextAlign.center,
                    fontSize: 18,
                  ),

                  Gap(height: 30),

                  /// PASSWORD
                  AppInputWidgetTwo(
                    title: "Password",
                    controller: passwordController,
                    isPassWord: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter password";
                      }
                      if ((value ?? '').length < 6) {
                        return "Minimum 6 characters";
                      }
                      return null;
                    },
                  ),

                  /// CONFIRM PASSWORD
                  AppInputWidgetTwo(
                    title: "Confirm Password",
                    controller: confirmPasswordController,
                    isPassWord: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Confirm password";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  Gap(height: 30),

                  /// BUTTON
                  AppButton(
                    title: "Continue",
                    trailing: Icons.arrow_forward,
                    onTap: isLoading ? null : resetPassword,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
