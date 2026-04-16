import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_about_section.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_action_section.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_header_image.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_info_row.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_location_map.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_photo_grid.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_review_card.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_scchedule_scetion.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_service_section.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/business_profile_share_screen.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/widget/rating_widget.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/verified_badge.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class BusinessProfile extends StatelessWidget {
  const BusinessProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: "Business Profile",
        actions: [
          IconButton(
            onPressed: () => BusinessProfileShareSheet.show(context),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Image Section
            BusinessProfileHeaderImage(
              coverImage:
              'https://images.unsplash.com/photo-1584622650111-993a426fbf0a',
              logoImage:
              'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
              onSeeAllTap: () {
                AppRoutes.instance.pushNamed(
                  AppRoutesKey.instance.businessProfilePhotosScreen,
                );
              },
            ),
            Gap(height: 16),

            // 2. Title & Rating Section
            AppText(
              text: "Elite Home Cleaners",
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
            Gap(height: 8),

            VerifiedBadge(
              backgroundColor: AppColors.instance.redOrange,
              textColor: AppColors.instance.black500,
              iconColor: AppColors.instance.black500,
            ),
            Gap(height: 8),

            const RatingWidget(rating: 4.8, totalReviews: 80),
            Gap(height: 8),

            BusinessProfileInfoRow(
              icon: Icons.shield_outlined,
              text: "identity Verified",
              iconColor: AppColors.instance.success,
              textColor: AppColors.instance.success,
              iconSize: 14,
              fontSize: 14,
            ),
            BusinessProfileInfoRow(
              icon: Icons.location_on_outlined,
              text: "identity Verified",
            ),
            BusinessProfileInfoRow(
              icon: Icons.check_circle_outline_outlined,
              text: "identity Verified",
            ),
            Gap(height: 20),

            BusinessProfileActionSection(),
            Gap(height: 20),

            // 4. Business Hours Section
            BusinessProfileSecheduleScetion(),
            Gap(height: 20),

            BusinessProfileAboutSection(),
            Gap(height: 20),

            BusinessProfileServiceSection(),
            Gap(height: 20),

            GestureDetector(
              onTap: () {
                AppRoutes.instance.pushNamed(
                  AppRoutesKey.instance.businessProfilePhotosScreen,
                );
              },
              child: BusinessProfilePhotoGrid(
                imageUrls: [
                  'https://picsum.photos/400/400?random=1',
                  'https://picsum.photos/400/400?random=2',
                  'https://picsum.photos/200/200?random=3',
                  'https://picsum.photos/200/200?random=4',
                  'https://picsum.photos/200/200?random=5',
                  'https://picsum.photos/200/200?random=6',
                  'https://picsum.photos/200/200?random=7',
                  'https://picsum.photos/200/200?random=8',
                  'https://picsum.photos/200/200?random=9',
                ],
              ),
            ),
            Gap(height: 30),

            BusinessProfileLocationMap(),
            Gap(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Reviews",
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
                GestureDetector(
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.businessProfileReviewScreen,
                    );
                  },
                  child: AppText(
                    text: "Write a review",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.instance.buttonColor,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) =>
                  BusinessProfileReviewCard(
                    name: "Sarah Jenkins",
                    date: "Oct 2023",
                    imageUrl: "https://i.pravatar.cc/150?img=11",
                    rating: 5,
                    review:
                    "Absolutely impeccable. The team arrived on time, were incredibly respectful of my home office space, and the attention to detail on the glass surfaces was beyond what I expected.",
                  ),
            ),
            Gap(height: 30),
          ],
        ),
      ),
    );
  }
}



class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const SocialIcon({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black54, size: 24),
        ),
        const Gap(height: 8),
        AppText(
          text: label,
          fontSize: 10,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}