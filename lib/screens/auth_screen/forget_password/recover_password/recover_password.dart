import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
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
  String email = "";

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = GoRouterState.of(context).extra;

    if (args != null && args is Map) {
      token = args["token"] ?? "";
      email = args["email"] ?? "";
    }
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    if (token.isEmpty || email.isEmpty) {
      AppSnackBar.instance.error("Invalid session");
      return;
    }

    final success = await ref
        .read(recoverPasswordProvider.notifier)
        .resetPassword(
          token: token,
          email: email,
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(),
        );

    if (!mounted) return;

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
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: "",
        backgroundColor: Colors.transparent,
      ),
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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

                  AppInputWidgetTwo(
                    title: "Password",
                    controller: passwordController,
                    isPassWord: true,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                  ),

                  AppInputWidgetTwo(
                    title: "Confirm Password",
                    controller: confirmPasswordController,
                    isPassWord: true,
                    textInputAction: TextInputAction.done,
                    isPassWordSecondValidation: true,
                    isPassWordSecondValidationController: passwordController,
                    maxLines: 1,
                  ),

                  Gap(height: 30),

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
      ), 
    );
  }
}
