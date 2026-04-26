import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/sign_up_screen/provider/sign_up_provider.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/sign_up_screen/widget/sign_up_input_field.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpProvider);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraNameLogo,
                    width: 116,
                  ),

                  Gap(height: 40),

                  AppText(
                    text: 'Welcome to Gidira',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),

                  Gap(height: 40),

                  SignUpInputField(
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    emailController: emailController,
                    phoneController: phoneController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),

                  Gap(height: 24),

                  Consumer(
                    builder: (context, ref, child) {
                      var provider = ref.watch(signUpProvider);
                      return AppButton(
                        title: state.isLoading ? "Loading..." : "Continue",
                        onTap: state.isLoading
                            ? null
                            : () async {
                                final notifier = ref.read(
                                  signUpProvider.notifier,
                                );

                                FocusScope.of(context).unfocus();

                                notifier.update(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                  confirmPassword: confirmPasswordController
                                      .text
                                      .trim(),
                                );

                                final success = await notifier.signUp(_formKey);

                                if (!mounted) return;

                                if (success) {
                                  AppRoutes.instance.pushNamed(
                                    AppRoutesKey.instance.otpVerificationScreen,
                                    extra: emailController.text.trim(),
                                  );
                                }
                              },
                      );
                    },
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
