import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/provider/login_provider.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/widget/phone_input_field.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_social_button.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_text_span.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(loginProvider);

    return Scaffold(
      body: Container(
        width: AppSize.size.width, 
        height: AppSize.size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraNameLogo,
                    width: 116,
                  ),
                  Gap(height: 35),
                  AppText(
                    text: 'Welcome to Gidira',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                  Gap(height: 10),
                  AppText(
                    text: 'Enter your phone number or gmail to get started',
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  Gap(height: 35),

                  PhoneInputField(),

                  Gap(height: 20),

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

                  Gap(height: 35),

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

                  Gap(height: 35),

                  Row(
                    children: [
                      Expanded(
                        child: CustomSocialButton(
                          label: "Google",
                          icon: AppAssertsIconsPath
                              .instance
                              .logosGoogleIcon,
                          color: Colors.red,
                          onTap: () async {
                            final success = await ref
                                .read(loginProvider.notifier)
                                .signInWithGoogle();
                            if (success) {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey
                                    .instance
                                    .appNavigationScreen,
                              );
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Google Sign-In failed",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Gap(width: 8),
                      Expanded(
                        child: CustomSocialButton(
                          label: "Apple",
                          icon:
                              AppAssertsIconsPath.instance.appleIcon,
                          color: Colors.black,
                          onTap: () async {
                            final success = await ref
                                .read(loginProvider.notifier)
                                .signInWithApple();
                            if (success) {
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey
                                    .instance
                                    .appNavigationScreen,
                              );
                            } else {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Apple Sign-In failed",
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(height: 35),

                  CustomTextSpan(
                    secondHighLightText: "Privacy Policy",
                    firstOnTap: () {},
                    secondOnTap: () {},
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
