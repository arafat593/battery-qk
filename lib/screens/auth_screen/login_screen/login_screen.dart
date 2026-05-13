import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/widget/phone_input_field.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import '../../../constant/app_asserts_icons_path.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes_key.dart';
import '../../../utils/gap.dart';
import '../../../widgets/app_image/app_image.dart';
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
  

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
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
                            Gap(height: 35),
                            AppText(
                              text: 'Welcome to Gidira',
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                            ),
                            Gap(height: 10),
                            AppText(
                              text:
                                  'Enter your phone number or gmail to get started',
                              textAlign: TextAlign.center,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            Gap(height: 35),
            
                            PhoneInputField(
                            ),
            
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
                                      final success = await ref.read(loginProvider.notifier).signInWithGoogle();
                                      if (success) {
                                        AppRoutes.instance.pushNamed(AppRoutesKey.instance.appNavigationScreen);
                                      } else {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Google Sign-In failed")),
                                        );
                                      }
                                    },
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
                                    isLoading: false, // Not implemented yet
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
          ),
        ],
      ),
    );
  }
}
