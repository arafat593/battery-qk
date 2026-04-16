import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';

import '../../../widgets/app_image/app_image_circular.dart';
import '../../../widgets/texts/app_text.dart';

class BusinessProfileServiceItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback? onTap;

  const BusinessProfileServiceItem({
    super.key,
    required this.name,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.instance.hintText.withAlpha(120),
              child: AppImage(path: imagePath, fit: BoxFit.cover, width: 18),
            ),
            Gap(width: 15),
            AppText(text: name, fontWeight: FontWeight.w600, fontSize: 16),
          ],
        ),
      ),
    );
  }
}
