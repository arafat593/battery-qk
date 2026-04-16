import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

import '../../../constant/app_colors.dart';
import '../../../widgets/texts/app_text.dart';

class BusinessProfilePhotoGrid extends StatelessWidget {
  final List<String> imageUrls;

  const BusinessProfilePhotoGrid({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    int totalImages = imageUrls.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.instance.white50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey.shade50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text:
          "Photos",
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          Gap(height: 16),

          // --- Top Row (1 or 2 images) ---
          if (totalImages > 0)
            Row(
              children: [
                Expanded(child: _buildImage(imageUrls[0], height: 180)),
                if (totalImages > 1) ...[
                  Gap(width: 10),
                  Expanded(child: _buildImage(imageUrls[1], height: 180)),
                ],
              ],
            ),

          Gap(height: 10),

          // --- Bottom Row (Up to 3 images) ---
          if (totalImages > 2)
            Row(
              children: [
                // 3rd Image
                Expanded(child: _buildImage(imageUrls[2], height: 120)),
                Gap(width: 10),

                // 4th Image
                if (totalImages > 3)
                  Expanded(child: _buildImage(imageUrls[3], height: 120))
                else
                  const Spacer(), // Placeholder jodi 4th image na thake

                Gap(width: 10),

                // 5th Image Slot (With 'More' logic)
                if (totalImages > 4)
                  Expanded(
                    child: Stack(
                      children: [
                        _buildImage(imageUrls[4], height: 120),
                        if (totalImages > 5)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: AppText(text:
                                  "More (+${totalImages - 5})",
                                  fontSize: 16,
                                  color: AppColors.instance.white50,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
        ],
      ),
    );
  }

  // Common image builder helper
  Widget _buildImage(String url, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}