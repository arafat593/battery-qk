import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile_review_screen/provider/business_profile_review_provider.dart';
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

class BusinessProfileReviewScreen extends ConsumerWidget {
  final int businessId;
  final String businessName;
  final String? businessLogo;
  final String location;

  const BusinessProfileReviewScreen({
    super.key,
    required this.businessId,
    required this.businessName,
    this.businessLogo,
    required this.location,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(businessProfileReviewProvider(BusinessReviewArgs(id: businessId, name: businessName)));
    final notifier = ref.read(businessProfileReviewProvider(BusinessReviewArgs(id: businessId, name: businessName)).notifier);

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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), 
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: AppImageCircular(
                      borderRadius: 16,
                      url: businessLogo ?? "https://picsum.photos/200/200?random=6",
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const Gap(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.instance.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppText(
                            text: "CURRENTLY REVIEWING",
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.instance.error,
                          ),
                        ),
                        const Gap(height: 8),
                        AppText(
                          text: businessName,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        const Gap(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 12, color: AppColors.instance.hintText),
                            const Gap(width: 4),
                            Expanded(
                              child: AppText(
                                text: location,
                                fontSize: 12,
                                color: AppColors.instance.hintText,
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
            Gap(height: 32),

            AppText(
              text: "How was your experience?",
              fontSize: 14,
              color: AppColors.instance.hintText,
            ),
            Gap(height: 16),

            // Star Rating Row (Interactive)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starRating = index + 1.0;
                return GestureDetector(
                  onTap: () => notifier.updateRating(starRating),
                  child: Icon(
                    starRating <= state.rating ? Icons.star : Icons.star_border,
                    color: AppColors.instance.error,
                    size: 40,
                  ),
                );
              }),
            ),
            const Gap(height: 8),
            AppText(
              text: _getRatingText(state.rating),
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
              controller: notifier.reviewController,
              minLines: 5,
              fillColor: AppColors.instance.hintText.withAlpha(80),
              hintText: "Describe your experience with this service...",
              hintStyle: TextStyle(color: AppColors.instance.hintText),
              style: TextStyle(color: AppColors.instance.black500),
            ),

            Gap(height: 20),

            // Anonymous Switch Row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          text: "Submit Anonymously",
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        AppText(
                          text: "Hide your name and profile details",
                          color: AppColors.instance.deepHintText,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: state.isAnonymous,
                    onChanged: (value) => notifier.toggleAnonymous(),
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.instance.success,
                  ),
                ],
              ),
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
                GestureDetector(
                  onTap: () => notifier.pickImage(),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined),
                        AppText(
                          text: "UPLOAD",
                          fontSize: 10,
                          color: AppColors.instance.hintText,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Image List
                Expanded(
                  child: SizedBox( 
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.images.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(state.images[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => notifier.removeImage(index),
                                child: const CircleAvatar(
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
              isLoading: state.isLoading,
              onTap: () => notifier.submitReview(),
              title: "Submit Review",
              trailing: Icons.play_arrow_outlined,
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return "SELECT RATING";
    if (rating <= 1) return "POOR";
    if (rating <= 2) return "FAIR";
    if (rating <= 3) return "GOOD";
    if (rating <= 4) return "VERY GOOD";
    return "EXCELLENT";
  }
}
