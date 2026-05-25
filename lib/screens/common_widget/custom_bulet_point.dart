import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class CustomBulletPoint extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double fontSize;
  final Color? textColor;
  final EdgeInsetsGeometry padding;

  const CustomBulletPoint({
    super.key,
    required this.text,
    this.icon = Icons.check_circle_outline,
    this.iconColor = Colors.green,
    this.iconSize = 18,
    this.fontSize = 16,
    this.textColor,
    this.padding = const EdgeInsets.only(bottom: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: AppText(
              text: text,
              fontSize: fontSize,
              color: AppColors.instance.deepHintText,
            ),
          ),
        ],
      ),
    );
  }
}
