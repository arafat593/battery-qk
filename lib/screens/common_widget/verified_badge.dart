import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class VerifiedBadge extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool showIcon;

  const VerifiedBadge({
    super.key,
    this.text = "VERIFIED",
    this.icon = Icons.check_circle,
    this.backgroundColor = const Color(0xFF1565C0), // blue[800]
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.fontSize = 10,
    this.iconSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 20,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, color: iconColor, size: iconSize),
            const Gap(width: 4),
          ],
          AppText(
            text: text,
            fontSize: fontSize,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
