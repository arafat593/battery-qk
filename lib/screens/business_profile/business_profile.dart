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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/business_profile/provider/business_profile_provider.dart';

class BusinessProfile extends ConsumerWidget {
  final int businessId;
  const BusinessProfile({super.key, required this.businessId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(businessProfileProvider(businessId));
    final details = state.businessDetails;

    if (state.isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: "Business Profile"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
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
              coverImage: (details?['cover_photo_urls'] is List && (details?['cover_photo_urls'] as List).isNotEmpty)
                  ? details!['cover_photo_urls'][0]
                  : details?['logo_url'] ?? 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a',
              logoImage: details?['logo_url'] ?? 'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
              onSeeAllTap: () {
                AppRoutes.instance.pushNamed(
                  AppRoutesKey.instance.businessProfilePhotosScreen,
                );
              },
            ),
            Gap(height: 16),

            // 2. Title & Rating Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    text: details?['business_name'] ?? "Business Profile",
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(businessProfileProvider(businessId).notifier).toggleFavorite();
                  },
                  icon: Icon(
                    state.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: state.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),

            if (details?['verification_status'] == 'approved') ...[  
              VerifiedBadge(
                backgroundColor: AppColors.instance.redOrange,
                textColor: AppColors.instance.black500,
                iconColor: AppColors.instance.black500,
              ),
              Gap(height: 8),
            ],

            RatingWidget(
              rating: (details?['average_rating'] ?? 0.0).toDouble(),
              totalReviews: details?['reviews_count'] ?? 0,
            ),
            Gap(height: 8),

            BusinessProfileInfoRow(
              icon: Icons.shield_outlined,
              text: details?['verification_status'] == 'approved' ? "Identity Verified" : "Pending Verification",
              iconColor: details?['verification_status'] == 'approved' ? AppColors.instance.success : AppColors.instance.hintText,
              textColor: details?['verification_status'] == 'approved' ? AppColors.instance.success : AppColors.instance.hintText,
              iconSize: 14,
              fontSize: 14,
            ),
            BusinessProfileInfoRow(
              icon: Icons.location_on_outlined,
              text: details?['location']?['full_name'] ?? "Location not set",
            ),
            BusinessProfileInfoRow(
              icon: Icons.check_circle_outline_outlined,
              text: details?['business_status'] == 'active' ? "Business is Active" : "Business Inactive",
            ),
            Gap(height: 20),

            BusinessProfileActionSection(
              phone: details?['phone'],
              whatsapp: details?['whatsapp'],
              website: details?['website'],
              isFavorite: state.isFavorite,
              onFavoriteTap: () {
                ref.read(businessProfileProvider(businessId).notifier).toggleFavorite();
              },
            ),
            Gap(height: 20),

            // 4. Business Hours Section
            BusinessProfileSecheduleScetion(),
            Gap(height: 20),

            BusinessProfileAboutSection(
              description: details?['business_description'],
            ),
            Gap(height: 20),

            BusinessProfileServiceSection(
              services: details?['services_offered'] is List
                  ? List<String>.from(details!['services_offered'])
                  : [],
              category: details?['category']?['name'],
            ),
            Gap(height: 20),

            GestureDetector(
              onTap: () {
                AppRoutes.instance.pushNamed(
                  AppRoutesKey.instance.businessProfilePhotosScreen,
                );
              },
              child: BusinessProfilePhotoGrid(
                imageUrls: (details?['cover_photo_urls'] is List && (details?['cover_photo_urls'] as List).isNotEmpty)
                    ? List<String>.from(details!['cover_photo_urls'])
                    : [
                        details?['logo_url'] ?? 'https://picsum.photos/400/400?random=1',
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
                      pathParameters: {"id": businessId.toString()},
                      extra: {
                        "name": details?['business_name'],
                        "logo": details?['logo_url'],
                        "location": details?['location']?['full_name'],
                      },
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
              itemCount: state.reviews.length,
              itemBuilder: (context, index) {
                var review = state.reviews[index];
                return BusinessProfileReviewCard(
                  name: review['full_name'] ?? "Anonymous",
                  date: review['created_at'] ?? "",
                  imageUrl: "https://i.pravatar.cc/150?img=${index + 1}",
                  rating: (review['rating'] ?? 5).round(),
                  review: review['review_text'] ?? "", 
                );
              },
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