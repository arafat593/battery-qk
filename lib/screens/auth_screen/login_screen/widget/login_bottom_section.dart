import 'package:flutter/material.dart';

class LoginBottomSection extends StatelessWidget {
  final String prefixText;
  final String termsText;
  final String privacyText;
  final Color normalColor;
  final Color highlightColor;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const LoginBottomSection({
    super.key,
    this.prefixText = "By continuing, you agree to ",
    this.termsText = "Terms of Service",
    this.privacyText = "Privacy Policy",
    this.normalColor = Colors.grey,
    this.highlightColor = Colors.red,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: normalColor, fontSize: 14),
        children: [
          TextSpan(text: prefixText),

          WidgetSpan(
            child: GestureDetector(
              onTap: onTermsTap,
              child: Text(
                termsText,
                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              ),
            ),
          ),

          const TextSpan(text: " and "),

          WidgetSpan(
            child: GestureDetector(
              onTap: onPrivacyTap,
              child: Text(
                privacyText,
                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}