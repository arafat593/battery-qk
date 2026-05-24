import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../utils/app_size.dart';
import 'verified_badge.dart';

//// ---------------- PROFESSIONAL CARD ----------------
class ProfessionalCard extends StatelessWidget {
  final String name;
  final double rating;
  final int reviews;
  final String imageUrl;
  final Function()? onTap;
  final double? width;

  const ProfessionalCard({
    super.key,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size.width * 0.01,
          vertical: AppSize.size.height * 0.01,
        ),
        child: Container(
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AppImage(
                      url: imageUrl,
                      height: 140,
                      width: width ?? double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(top: 8, left: 8, child: VerifiedBadge()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: name,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.red, size: 16),
                        AppText(
                          text: " $rating ",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        Gap(width: 4),
                        AppText(
                          text: "($reviews reviews)",
                          fontSize: 14,
                          color: AppColors.instance.hintText,
                        ),
                      ],
                    ),
                    Gap(height: 12),
                    AppButton(
                      backgroundColor: Colors.redAccent,
                      borderColor: Colors.redAccent,
                      leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
                      title: "Show phone number",
                    ),
                    Gap(height: 8),
                    AppButton(
                      backgroundColor: AppColors.instance.buttonColor.withAlpha(
                        15,
                      ),
                      borderColor: AppColors.instance.buttonColor,
                      leadingIconImage:
                          AppAssertsIconsPath.instance.messageIcon,
                      iconColor: AppColors.instance.buttonColor,
                      title: "Direct Message",
                      titleColor: AppColors.instance.buttonColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
