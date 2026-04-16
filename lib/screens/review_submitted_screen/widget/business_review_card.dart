import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../widgets/texts/app_text.dart';
import '../../business_profile/widget/rating_widget.dart';

class BusinessReviewCard extends StatelessWidget {
  final String businessName;
  final double rating;
  final String time;
  final String reviewText;
  final List<String> images;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BusinessReviewCard({
    super.key,
    required this.businessName,
    required this.rating,
    required this.time,
    required this.reviewText,
    required this.images,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header
          Row(
            children: [
              Icon(Icons.verified, color: AppColors.instance.red, size: 18),
              const SizedBox(width: 6),

              /// Business Name
              Expanded(
                child: AppText(
                  text: businessName,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              /// Edit Button
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColors.instance.deepHintText,
                  ),
                ),

              /// Delete Button
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.instance.deepHintText,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 Rating + Time
          Row(
            children: [
              RatingWidget(
                rating: rating,
                showText: false,
                filledColor: AppColors.instance.red,
              ),
              const SizedBox(width: 6),
              AppText(
                text: time,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.instance.deepHintText,
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 Review Text
          AppText(text: reviewText, color: AppColors.instance.deepHintText),

          const SizedBox(height: 12),

          /// 🔹 Images Grid (Only if available)
          if (images.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 🔥 better UI
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(images[index], fit: BoxFit.cover),
                );
              },
            ),
        ],
      ),
    );
  }
}
