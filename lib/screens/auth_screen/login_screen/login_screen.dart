import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/widget/login_bottom_section.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/widget/phone_input_field.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/widget/social_button.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFDEE9F7), // Light blue top-left
              Colors.white, // White middle
              Color(0xFFDEE9F7), // Light blue bottom-right
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Gap(),
                // Logo
                Column(
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
                      text: 'Enter your phone number to get started',
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),

                    Gap(height: 40),
                    PhoneInputField(),
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
                          child: SocialButton(
                            label: "Google",
                            icon: AppAssertsIconsPath.instance.logosGoogleIcon,
                            color: Colors.red,
                          ),
                        ),
                        Gap(width: 16),
                        Expanded(
                          child: SocialButton(
                            label: "Facebook",
                            icon:
                                AppAssertsIconsPath.instance.logosFacebookIcon,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Terms of Service
                LoginBottomSection(
                  onTermsTap: () {
                    print("Terms clicked");
                  },
                  onPrivacyTap: () {
                    print("Privacy clicked");
                  },
                ),
                Gap(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
