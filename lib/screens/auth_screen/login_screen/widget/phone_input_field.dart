import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/provider/login_provider.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';

class PhoneInputField extends ConsumerStatefulWidget {
  final Color? containerColor;
  final Color? textColor;

  const PhoneInputField({super.key, this.containerColor, this.textColor});

  @override
  ConsumerState<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends ConsumerState<PhoneInputField> {
  late TextEditingController emailTextEditingController;
  late TextEditingController passwordTextEditingController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> checkLoginFunction() async {
    try {
      if (!formKey.currentState!.validate()) return;

      final response = await ref
          .read(loginProvider.notifier)
          .signIn(
            emailTextEditingController.text.trim(),
            passwordTextEditingController.text.trim(),
          );

      if (response) {
        AppRoutes.instance.pushReplacement(
          AppRoutesKey.instance.appNavigationScreen,
        );
      }
      // else {
      //   AppSnackBar.instance.error("Invalid email or password. Please try again.");
      // }
    } catch (e) {
      errorLog("checkLoginFunction", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppInputWidgetTwo(
            validator: (String? value) {
              if (value?.isEmpty == true) {
                return "Enter your email";
              }
              return null;
            },
            title: "phone number/email",
            controller: emailTextEditingController,
            textInputAction: TextInputAction.next,
          ),
          AppInputWidgetTwo(
            title: "Password",
            controller: passwordTextEditingController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            isPassWord: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return "Enter your password";
              }
              if ((value ?? '').length < 6) {
                return "At least 6 characters";
              }
              return null;
            },
          ),
          Gap(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                AppRoutes.instance.pushNamed(
                  AppRoutesKey.instance.forgetPassword,
                );
              },
              child: AppText(
                text: "FORGET PASSWORD",
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.instance.primary,
              ),
            ),
          ),
          Gap(height: 20),
          Consumer(
            builder: (context, ref, child) {
              final provider = ref.watch(loginProvider);
              return AppButton(
                title: "Continue",
                trailing: Icons.arrow_forward,
                onTap: checkLoginFunction,
                isLoading: provider,
              );
            },
          ),
        ],
      ),
    );
  }
}
