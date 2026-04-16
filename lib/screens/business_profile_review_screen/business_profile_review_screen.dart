import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/rating_widget.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image_circular.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../routes/app_routes.dart';
import '../../routes/app_routes_key.dart';
import '../../utils/gap.dart';

class BusinessProfileReviewScreen extends StatelessWidget {
  const BusinessProfileReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Write a Review"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Business Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.instance.hintText.withAlpha(30),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  AppImageCircular(
                    borderRadius: 24,
                    url: "https://picsum.photos/200/200?random=6",
                    width: 80,
                  ),
                  Gap(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: "CURRENTLY REVIEWING",
                        fontSize: 10,
                        color: AppColors.instance.error,
                      ),
                      Gap(height: 10),
                      AppText(
                        text: "Luxe Clean Solutions",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      Gap(height: 10),
                      AppText(
                        text: "Lagos, Nigeria",
                        fontSize: 14,
                        color: AppColors.instance.hintText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(height: 32),

            AppText(
              text: "How was your experience?",
              fontSize: 14,
              color: AppColors.instance.hintText,
            ),
            Gap(height: 16),

            // Star Rating Row
            RatingWidget(
              totalReviews: 5,
              rating: 4.1,
              showText: false,
              filledColor: AppColors.instance.error,
              iconSize: 30,
              maxRating: 5,
            ),
            Gap(height: 8),
            AppText(
              text: "VERY GOOD",
              fontSize: 12,
              color: AppColors.instance.hintText,
            ),

            Gap(height: 32),

            // Experience Text Field
            const Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: "Share your experience",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(height: 12),
            AppInputWidget(
              minLines: 5,
              fillColor: AppColors.instance.hintText.withAlpha(80),
              hintText: "Describe your experience with this service...",
              hintStyle: TextStyle(color: AppColors.instance.hintText),
            ),

            Gap(height: 24),

            // Photo Upload Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Add Photos",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text: "Optional",
                  fontSize: 12,
                  color: AppColors.instance.hintText,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Upload Placeholder
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      AppText(
                        text: "UPLOAD",
                        fontSize: 10,
                        color: AppColors.instance.hintText,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Image List
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            AppImageCircular(
                              borderRadius: 12,
                              url: 'https://picsum.photos/200/200?random=6',
                              width: 100,
                              height: 100,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  // delete action
                                },
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(height: 16),
            AppButton(
              onTap: () {
                AppRoutes.instance.pushNamed(
                  AppRoutesKey.instance.reviewSubmittedScreen,
                );
              },
              title: "Submit Review",
              trailing: Icons.play_arrow_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
