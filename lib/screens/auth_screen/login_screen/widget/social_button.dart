import 'package:flutter/material.dart';

import '../../../../widgets/app_image/app_image.dart';
import '../../../../widgets/texts/app_text.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String icon;
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
      icon: AppImage(path: icon, width: 20),
      label: AppText(text: label, fontSize: 14, fontWeight: FontWeight.w700),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.blue.shade100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blue.withOpacity(0.05),
      ),
    );
  }
}