import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../../utils/gap.dart';

class RatingWidget extends StatelessWidget {
  final double rating; // e.g. 4.0, 3.5
  final int totalReviews;
  final int maxRating;
  final double iconSize;
  final Color filledColor;
  final Color emptyColor;
  final bool showText;

  const RatingWidget({
    super.key,
    required this.rating,
    this.totalReviews = 0,
    this.maxRating = 5,
    this.iconSize = 18,
    this.filledColor = Colors.orange,
    this.emptyColor = Colors.grey,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(maxRating, (index) {
            if (index < rating.floor()) {
              // full star
              return Icon(Icons.star, color: filledColor, size: iconSize);
            } else if (index < rating) {
              // half star
              return Icon(Icons.star_half, color: filledColor, size: iconSize);
            } else {
              // empty star
              return Icon(Icons.star_border, color: emptyColor, size: iconSize);
            }
          }),
        ),
        if (showText) ...[
          const Gap(width: 8),
          AppText(
            text: "$rating ($totalReviews Reviews)",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ],
      ],
    );
  }
}
