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

  const BusinessProfileReviewCard({
    super.key,
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
