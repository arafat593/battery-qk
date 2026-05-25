import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class BusinessProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const BusinessProfileInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.redAccent,
    this.textColor = Colors.black,
    this.iconSize = 24,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          Gap(width: spacing),
          Expanded(
            child: AppText(
              text: text,
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
