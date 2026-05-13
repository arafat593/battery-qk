import 'package:flutter/material.dart';

import '../../widgets/app_image/app_image.dart';
import '../../widgets/texts/app_text.dart';

class CustomSocialButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;

  const CustomSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.blue.shade100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blue.withOpacity(0.05),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(path: icon, width: 20),
                const SizedBox(width: 8),
                AppText(text: label, fontSize: 14, fontWeight: FontWeight.w700),
              ],
            ),
    );
  }
}
