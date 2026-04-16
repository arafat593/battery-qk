import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;

  /// Optional action (View All / See More / etc.)
  final String? actionText;
  final VoidCallback? onActionTap;

  /// Styling
  final double? titleSize;
  final FontWeight? titleWeight;
  final Color? titleColor;

  final double? actionSize;
  final FontWeight? actionWeight;
  final Color? actionColor;

  /// Layout
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;

  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.titleSize,
    this.titleWeight,
    this.titleColor,
    this.actionSize,
    this.actionWeight,
    this.actionColor,
    this.padding,
    this.alignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: AppSize.height(value: 16)),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          /// Title
          Expanded(
            child: AppText(
              text: title,
              fontSize: titleSize ?? 24,
              fontWeight: titleWeight ?? FontWeight.w700,
              color: titleColor,
            ),
          ),

          /// Action Button
          if (actionText != null)
            TextButton(
              onPressed: onActionTap ?? () {},
              child: AppText(
                text: actionText!,
                fontSize: actionSize ?? 14,
                fontWeight: actionWeight ?? FontWeight.w500,
                color: actionColor ?? Colors.redAccent,
              ),
            ),
        ],
      ),
    );
  }
}