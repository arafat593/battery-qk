import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image_circular.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class BusinessProfileReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final String imageUrl;
  final int rating;
  final String review;
  final List<String>? reviewImages;

  const BusinessProfileReviewCard({
    super.key,
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.rating,
    required this.review,
    this.reviewImages,
  });

  @override
  Widget build(BuildContext context) {
    bool showImages = reviewImages != null && reviewImages!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImageCircular(url: imageUrl, width: 48),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: name,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      text: date,
                      fontSize: 14,
                      color: AppColors.instance.hintText,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Stars
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: index < rating
                          ? const Color(0xFFE93544)
                          : Colors.grey[300],
                    );
                  }),
                ),

                const SizedBox(height: 10),

                // Review Text
                AppText(
                  text: review,
                  fontSize: 16,
                  color: AppColors.instance.hintText,
                ),

                if (showImages) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: reviewImages!.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            reviewImages![index],
                            width: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 80,
                                color: Colors.grey[100],
                                child: const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFE93544),
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
