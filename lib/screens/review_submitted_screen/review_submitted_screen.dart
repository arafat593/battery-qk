import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/rating_widget.dart';
import 'package:olabisiolai_flutter_app/screens/review_submitted_screen/widget/business_review_card.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../widgets/custom_app_bar/custom_app_bar.dart';

class ReviewSubmittedScreen extends StatelessWidget {
  const ReviewSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Review Submitted'),
      body: Stack(
        children: [
          // 1. Background Glow Effect
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withAlpha(200),
                    Colors.blue.withAlpha(1),
                  ],
                ),
              ),
            ),
          ),

          // 2. Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Gap(height: 40),
                  // Success Icon
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.instance.red,
                        // Adjust to your theme red
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Gap(height: 32),
                  AppText(
                    text: "Review Submitted!",
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                  Gap(height: 12),
                  AppText(
                    text:
                        "Thank you for helping the Gidira community stay verified and trusted. Your feedback makes a difference.",
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    color: AppColors.instance.hintText,
                  ),
                  Gap(height: 40),

                  // 3. Review Detail Card
                  BusinessReviewCard(
                    businessName: "Luxe Clean Solutions",
                    rating: 5,
                    time: "2 days ago",
                    reviewText: "Amazing service! Everything was spotless.",
                    images: List.generate(
                      6,
                      (index) => 'https://picsum.photos/200/200?random=$index',
                    ),
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  Gap(height: 16),
                  AppButton(
                    title: "Back to Profile",
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.appNavigationScreen,
                      );
                    },
                  ),
                  Gap(height: 16),
                  AppButton(
                    title: "Go to Home Feed",
                    backgroundColor: AppColors.instance.transparent,
                    borderColor: AppColors.instance.black500,
                    titleColor: AppColors.instance.black500,
                    onTap: () {
                      AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.appNavigationScreen,
                      );
                    },
                  ),
                  Gap(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
