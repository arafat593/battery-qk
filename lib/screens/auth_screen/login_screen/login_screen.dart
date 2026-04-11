import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/constant/app_constant.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget_tow.dart';
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
                const SizedBox(height: 60),

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
                    const SizedBox(height: 12),
                    AppText(
                      text: 'Enter your phone number to get started',
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),

                    Gap(height: 40),

                    // Phone Number Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        text: "PHONE NUMBER",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gap(height: 8),

                    PhoneInputField(),

                    Gap(height: 24),

                    AppButton(title: "Continue", trailing: Icons.arrow_forward),

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

                    Gap(height: 30),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SocialButton(
                            label: "Google",
                            icon: Icons.g_mobiledata,
                            color: Colors.red,
                          ),
                        ),
                        Gap(width: 16),

                        Expanded(
                          child: SocialButton(
                            label: "Facebook",
                            icon: Icons.facebook,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Terms of Service
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    children: [
                      TextSpan(text: "By continuing, you agree to Gidira's "),
                      TextSpan(
                        text: "Terms of Service",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: " and "),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
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
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const SocialButton({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: color),
      label: Text(label, style: const TextStyle(color: Colors.black87)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.blue.shade100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blue.withOpacity(0.05),
      ),
    );
  }
}

class PhoneInputField extends StatefulWidget {
  @override
  _PhoneInputFieldState createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  // Default country: Nigeria
  String _countryCode = "234";
  String _flagEmoji = "🇳🇬";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.instance.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Country Picker Trigger
          InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                countryListTheme: CountryListThemeData(
                  textStyle: TextStyle(
                    color: AppColors.instance.black500,
                    fontSize: 16,
                  ),
                  searchTextStyle: TextStyle(
                    color: AppColors.instance.black500,
                  ),
                ),
                onSelect: (Country country) {
                  setState(() {
                    _countryCode = country.phoneCode;
                    _flagEmoji = country.flagEmoji;
                  });
                },
              );
            },
            child: Row(
              children: [
                AppText(text: _flagEmoji, fontSize: 24),
                const SizedBox(width: 8),
                AppText(
                  text: "+$_countryCode",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),

          // Vertical Divider
          Container(
            height: 24,
            width: 1,
            color: Colors.grey[400],
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // Input Field
          Expanded(
            child: AppInputWidget(
              fillColor: AppColors.instance.containerColor,
              textColor: AppColors.instance.black500,
            ),
          ),
        ],
      ),
    );
  }
}
