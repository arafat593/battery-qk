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
import '../app_navigation_screen/app_navigation_screen.dart';

class ReviewSubmittedScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const ReviewSubmittedScreen({super.key, this.data});

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
                    businessName:
                        data?['business_name'] ?? "Luxe Clean Solutions",
                    rating: (data?['rating'] ?? 5.0).toDouble(),
                    time: "Just now",
                    reviewText:
                        data?['review_text'] ??
                        "Amazing service! Everything was spotless.",
                    images: data?['images'] is List
                        ? List<String>.from(data!['images'])
                        : [],
                    onEdit: () {
                      AppRoutes.instance.pop();
                    },
                    onDelete: () {
                      AppRoutes.instance.pop();
                    },
                  ),
                  Gap(height: 16),
                  AppButton(
                    title: "Back to Profile",
                    onTap: () {
                      if (data?['business_id'] != null) {
                        AppRoutes.instance.pushReplacementNamed(
                          AppRoutesKey.instance.businessProfile,
                          pathParameters: {
                            'id': data!['business_id'].toString(),
                          },
                        );
                      } else {
                        AppRoutes.instance.pushReplacementNamed(
                          AppRoutesKey.instance.appNavigationScreen,
                          queryParameters: {'index': '3'}, // Profile tab
                        );
                      }
                    },
                  ),
                  Gap(height: 16),
                  AppButton(
                    title: "Go to Home Feed",
                    backgroundColor: AppColors.instance.transparent,
                    borderColor: AppColors.instance.black500,
                    titleColor: AppColors.instance.black500,
                    onTap: () {
                      AppRoutes.instance.pushReplacementNamed(
                        AppRoutesKey.instance.appNavigationScreen,
                        queryParameters: {'index': '0'}, // Home tab
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
