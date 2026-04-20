import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/sign_up_screen/widget/sign_up_input_field.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_text_span.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_social_button.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/custom_check_box_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gap(),
                  // Logo
                  Form(
                    child: Column(
                      children: [
                        AppImage(
                          path: AppAssertsIconsPath.instance.gidiraNameLogo,
                          width: 116,
                        ),
                        Gap(height: 40),
                        // Welcome Text
                        AppText(
                          text: 'Welcome to Gidira',
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                        Gap(height: 12),
                        AppText(
                          text:
                              'Enter your phone number or gmail to get started',
                          textAlign: TextAlign.center,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),

                        Gap(height: 40),
                        SignUpInputField(),
                        Gap(height: 16),
                        Row(
                          children: [
                            CustomCheckBoxButton(onChange: (c) {}),
                            AppText(
                              text:
                                  "I want to receive emails about the feature \nBusiness, Direct message, and New listings.",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        Gap(height: 12),
                        CustomTextSpan(
                          secondHighLightText: "Privacy Policy",
                          prefixText:
                              "By creating an account, you agree to the  ",
                        ),
                        Gap(height: 24),
                        AppButton(
                          title: "Continue",
                          trailing: Icons.arrow_forward,
                          onTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.appNavigationScreen,
                            );
                          },
                        ),
                        Gap(height: 24),
                        CustomTextSpan(
                          prefixText: "Already have an account?  ",
                          highlightColor: AppColors.instance.primary,
                          isAnd: false,
                          firstHighLightText: "Log In",
                          firstOnTap: () {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.loginScreen,
                            );
                          },
                        ),

                        Gap(height: 40),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
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

                        // Social Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomSocialButton(
                                label: "Google",
                                icon: AppAssertsIconsPath
                                    .instance
                                    .logosGoogleIcon,
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
