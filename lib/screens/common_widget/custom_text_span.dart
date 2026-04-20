import 'package:flutter/material.dart';

class CustomTextSpan extends StatelessWidget {
  final String prefixText;
  final String firstHighLightText;
  final String? secondHighLightText;
  final Color normalColor;
  final Color highlightColor;
  final VoidCallback? firstOnTap;
  final VoidCallback? secondOnTap;
  final bool? isAnd;

  const CustomTextSpan({
    super.key,
    this.prefixText = "By continuing, you agree to ",
    this.firstHighLightText = "Terms of Service",
    this.secondHighLightText = "",
    this.normalColor = Colors.grey,
    this.highlightColor = Colors.red,
    this.firstOnTap,
    this.secondOnTap,
    this.isAnd = true,
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
              onTap: firstOnTap,
              child: Text(
                firstHighLightText,
                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          isAnd! ? TextSpan(text: " and ") : TextSpan(),

          WidgetSpan(
            child: GestureDetector(
              onTap: secondOnTap,
              child: Text(
                secondHighLightText!,
                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
