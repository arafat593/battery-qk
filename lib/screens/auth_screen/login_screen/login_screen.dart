import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/widget/phone_input_field.dart';
import '../../../constant/app_asserts_icons_path.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes_key.dart';
import '../../../utils/app_log.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/gap.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/texts/app_text.dart';
import '../../common_widget/custom_social_button.dart';
import '../../common_widget/custom_text_span.dart';
import 'provider/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
      } else {
        AppSnackBar.instance.error("Invalid email and password");
      }
    } catch (e) {
      errorLog("checkLoginFunction", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(),
                  Column(
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
                      Gap(height: 12),
                      AppText(
                        text: 'Enter your phone number or gmail to get started',
                        textAlign: TextAlign.center,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      Gap(height: 40),

                      PhoneInputField(
                        emailController: emailTextEditingController,
                        passwordController: passwordTextEditingController,
                      ),
                      Gap(height: 4),

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

                      Gap(height: 24),

                      Consumer(
                        builder: (context, ref, child) {
                          var provider = ref.watch(loginProvider);
                          return AppButton(
                            title: "Continue",
                            trailing: Icons.arrow_forward,
                            onTap: checkLoginFunction,
                            isLoading: provider,
                          );
                        },
                      ),

                      Gap(height: 24),

                      CustomTextSpan(
                        highlightColor: AppColors.instance.primary,
                        firstHighLightText: "Sign Up",
                        prefixText: "Don't have an account?  ",
                        isAnd: false,
                        firstOnTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.signUpScreen,
                          );
                        },
                      ),

                      Gap(height: 40),

                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: AppText(
                              text: "Or continue with",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.instance.hintText,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      Gap(height: 40),

                      Row(
                        children: [
                          Expanded(
                            child: CustomSocialButton(
                              label: "Google",
                              icon:
                                  AppAssertsIconsPath.instance.logosGoogleIcon,
                              color: Colors.red,
                            ),
                          ),
                          Gap(width: 16),
                          Expanded(
                            child: CustomSocialButton(
                              label: "Facebook",
                              icon: AppAssertsIconsPath
                                  .instance
                                  .logosFacebookIcon,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  CustomTextSpan(
                    secondHighLightText: "Privacy Policy",
                    firstOnTap: () {},
                    secondOnTap: () {},
                  ),

                  Gap(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
