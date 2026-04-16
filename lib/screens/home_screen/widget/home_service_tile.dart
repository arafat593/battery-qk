import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

import '../../../constant/app_colors.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/texts/app_text.dart';

//// ---------------- SERVICE TILE ----------------
class HomeServiceListTile extends StatelessWidget {
  final String title;
  final String location;
  final String distance;
  final double rating;

  const HomeServiceListTile({
    super.key,
    required this.title,
    required this.location,
    required this.distance,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                url:
                "https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg",
                width: 95,
                height: 95,
              ),
            ),
            Gap(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: title, fontWeight: FontWeight.w700),
                  Gap(height: 12,),
                  AppText(
                    text: "$location • $distance",
                    fontSize: 12,
                    color: AppColors.instance.hintText,
                  ),
                  Gap(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.red, size: 14),
                          AppText(
                            text: " $rating",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "VERIFIED",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}