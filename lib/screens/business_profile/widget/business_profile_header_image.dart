import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class BusinessProfileHeaderImage extends StatelessWidget {
  final String? coverImage;
  final String? logoImage;
  final VoidCallback? onSeeAllTap;
  final double height;
  final bool showSeeAll;
  final bool showLogo;

  const BusinessProfileHeaderImage({
    super.key,
    this.coverImage,
    this.logoImage,
    this.onSeeAllTap,
    this.height = 200,
    this.showSeeAll = true,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasCover = coverImage != null && coverImage!.isNotEmpty;
    final hasLogo = showLogo && logoImage != null && logoImage!.isNotEmpty;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          /// 🔹 Cover Image / Empty Placeholder
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasCover
                  ? AppImage(
                      url: coverImage!,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    ),
            ),
          ),

          /// 🔹 See All Button
          if (showSeeAll)
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: onSeeAllTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.instance.primary,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: AppText(
                    text: "See all Photos",
                    fontWeight: FontWeight.w500,
                    color: AppColors.instance.primary,
                  ),
                ),
              ),
            ),

          /// 🔹 Logo Image
          if (hasLogo)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.instance.black500,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppImage(
                    url: logoImage!,
                    width: 65,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}