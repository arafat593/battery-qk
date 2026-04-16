import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class MyReviewsCardWidget extends StatelessWidget {
  final String name;
  final String date;
  final String imageUrl;
  final int rating;
  final String review;
  final bool isVerified;
  final List<String>? reviewImages;
  final Function()? editButton;
  final Function()? deleteButton;

  const MyReviewsCardWidget({
    super.key,
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.rating,
    required this.review,
    this.isVerified = true,
    this.reviewImages,
    this.editButton,
    this.deleteButton,
  });

  @override
  Widget build(BuildContext context) {
    bool showImages = reviewImages != null && reviewImages!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isVerified)
                const Icon(Icons.verified, color: Color(0xFFE93544), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  text: name,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.blueGrey,
                ),
                onPressed: editButton,
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.blueGrey,
                ),
                onPressed: deleteButton,
              ),
            ],
          ),

          const SizedBox(height: 4),
          Row(
            children: [
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
              const SizedBox(width: 10),
              AppText(
                text: date,
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          const SizedBox(height: 12),

          AppText(text: review, fontSize: 15, color: Colors.blueGrey.shade700),

          if (showImages) ...[
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: reviewImages!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      reviewImages![index],
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
