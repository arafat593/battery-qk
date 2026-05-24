import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/texts/app_text.dart';

class AccountSettingSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? activeColor;
  final Color? activeTrackColor;

  const AccountSettingSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconBackgroundColor,
    this.iconColor,
    this.activeColor,
    this.activeTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBackgroundColor ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? Colors.grey[700]),
        ),
        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: title, fontWeight: FontWeight.w700, fontSize: 16),
              AppText(
                text: subtitle,
                color: AppColors.instance.deepHintText,
                fontSize: 14,
              ),
            ],
          ),
        ),

        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor ?? Colors.white,
          activeTrackColor: activeTrackColor ?? AppColors.instance.success,
        ),
      ],
    );
  }
}
