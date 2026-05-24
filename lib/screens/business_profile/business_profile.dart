import 'package:flutter/material.dart';
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

import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';

class BusinessProfile extends ConsumerStatefulWidget {
  final int businessId;
  const BusinessProfile({super.key, required this.businessId});

  @override
  ConsumerState<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends ConsumerState<BusinessProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(businessProfileProvider(widget.businessId).notifier)
          .fetchBusinessData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(businessProfileProvider(widget.businessId));
    final details = state.businessDetails;
    final List<String> photos =
        (details?['cover_photo_urls'] is List &&
            (details?['cover_photo_urls'] as List).isNotEmpty)
        ? List<String>.from(details!['cover_photo_urls'])
        : <String>[];

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
            onPressed: () => BusinessProfileShareSheet.show(
              context: context,
              businessName:
                  details?['business_name'] ??
                  details?['name'] ??
                  'Business Profile',
              logoUrl: details?['logo_url'],
              businessId: widget.businessId,
              categoryName: details?['category']?['name'],
            ),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(businessProfileProvider(widget.businessId).notifier)
            .fetchBusinessData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Image Section
              BusinessProfileHeaderImage(
                coverImage: photos.isNotEmpty ? photos[0] : null,
                logoImage:
                    (details?['logo_url'] != null &&
                        details!['logo_url'].toString().isNotEmpty)
                    ? details['logo_url']
                    : null,
                showSeeAll: true,
                onSeeAllTap: () {
                  AppRoutes.instance.pushNamed(
                    AppRoutesKey.instance.businessProfilePhotosScreen,
                    extra: photos,
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
                      ref
                          .read(
                            businessProfileProvider(widget.businessId).notifier,
                          )
                          .toggleFavorite();
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
                text: details?['verification_status'] == 'approved'
                    ? "Identity Verified"
                    : "Pending Verification",
                iconColor: details?['verification_status'] == 'approved'
                    ? AppColors.instance.success
                    : AppColors.instance.hintText,
                textColor: details?['verification_status'] == 'approved'
                    ? AppColors.instance.success
                    : AppColors.instance.hintText,
                iconSize: 14,
                fontSize: 14,
              ),
              BusinessProfileInfoRow(
                icon: Icons.location_on_outlined,
                text: details?['location']?['full_name'] ?? "Location not set",
              ),
              BusinessProfileInfoRow(
                icon: Icons.check_circle_outline_outlined,
                text: details?['business_status'] == 'active'
                    ? "Business is Active"
                    : "Business Inactive",
              ),
              Gap(height: 20),

              BusinessProfileActionSection(
                phone: details?['phone'],
                whatsapp: details?['whatsapp'],
                website: details?['website'],
                isFavorite: state.isFavorite,
                vendorUuid: details?['vendor']?['uuid']?.toString(),
                businessName:
                    details?['business_name'] ?? details?['name'] ?? "Chat",
                logoUrl: details?['logo_url'],
                onFavoriteTap: () {
                  ref
                      .read(businessProfileProvider(widget.businessId).notifier)
                      .toggleFavorite();
                },
                onShareTap: () {
                  BusinessProfileShareSheet.show(
                    context: context,
                    businessName:
                        details?['business_name'] ??
                        details?['name'] ??
                        'Business Profile',
                    logoUrl: details?['logo_url'],
                    businessId: widget.businessId,
                    categoryName: details?['category']?['name'],
                  );
                },
              ),
              Gap(height: 20),

              // 4. Business Hours Section
              BusinessProfileSecheduleScetion(
                businessHours:
                    details?['business_hours_display'] ??
                    details?['business_hours'],
              ),
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

              if (photos.isNotEmpty) ...[
                BusinessProfilePhotoGrid(imageUrls: photos),
                const Gap(height: 20),
              ],

              BusinessProfileLocationMap(
                latitude: details?['location']?['latitude'] != null
                    ? double.tryParse(
                        details!['location']['latitude'].toString(),
                      )
                    : null,
                longitude: details?['location']?['longitude'] != null
                    ? double.tryParse(
                        details!['location']['longitude'].toString(),
                      )
                    : null,
                locationName:
                    details?['location']?['full_name'] ??
                    details?['location']?['name'],
              ),
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
                    onTap: () async {
                      await AppRoutes.instance.pushNamed(
                        AppRoutesKey.instance.businessProfileReviewScreen,
                        pathParameters: {"id": widget.businessId.toString()},
                        extra: {
                          "name": details?['business_name'],
                          "logo": details?['logo_url'],
                          "location": details?['location']?['full_name'],
                        },
                      );
                      ref
                          .read(
                            businessProfileProvider(widget.businessId).notifier,
                          )
                          .fetchBusinessData();
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

                  // Parse details based on backend /reviews response
                  final name =
                      review['reviewer_name'] ??
                      review['full_name'] ??
                      "Anonymous";
                  final date =
                      review['created_at_human'] ?? review['created_at'] ?? "";

                  final isAnonymous =
                      review['is_anonymous'] == true || name == "Anonymous";

                  String avatarUrl = "";
                  if (!isAnonymous) {
                    final rawPhoto =
                        review['reviewer_photo'] ??
                        review['reviewer_image'] ??
                        review['avatar'] ??
                        review['user']?['photo'] ??
                        review['user']?['image_url'] ??
                        "";
                    if (rawPhoto.toString().isNotEmpty) {
                      avatarUrl = rawPhoto.toString();
                      if (avatarUrl.contains('/storage/')) {
                        final storagePath = avatarUrl.substring(
                          avatarUrl.indexOf('/storage/'),
                        );
                        avatarUrl = "${AppApiUrl.domain}$storagePath";
                      } else if (!avatarUrl.startsWith('http')) {
                        avatarUrl = "${AppApiUrl.domain}/storage/$avatarUrl";
                      }
                    }
                  }

                  if (avatarUrl.isEmpty) {
                    avatarUrl = isAnonymous
                        ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                        : "https://i.pravatar.cc/150?img=${review['id'] ?? index}";
                  }

                  String reviewText =
                      review['review_text'] ?? review['review'] ?? "";
                  // Strip leading and trailing escaped quotes if they exist
                  if (reviewText.startsWith('"') &&
                      reviewText.endsWith('"') &&
                      reviewText.length > 1) {
                    reviewText = reviewText.substring(1, reviewText.length - 1);
                  }

                  List<String> reviewImages = [];
                  final rawImages = review['images'] ?? review['photos'];
                  if (rawImages is List) {
                    for (var img in rawImages) {
                      if (img != null) {
                        String imgUrl = "";
                        if (img is Map) {
                          imgUrl =
                              img['url'] ??
                              img['image_url'] ??
                              img['path'] ??
                              img['image_path'] ??
                              "";
                        } else {
                          imgUrl = img.toString();
                        }
                        if (imgUrl.isNotEmpty) {
                          if (imgUrl.contains('/storage/')) {
                            final storagePath = imgUrl.substring(
                              imgUrl.indexOf('/storage/'),
                            );
                            imgUrl = "${AppApiUrl.domain}$storagePath";
                          } else if (!imgUrl.startsWith('http')) {
                            imgUrl = "${AppApiUrl.domain}/storage/$imgUrl";
                          }
                          reviewImages.add(imgUrl);
                        }
                      }
                    }
                  }

                  return BusinessProfileReviewCard(
                    name: name,
                    date: date,
                    imageUrl: avatarUrl,
                    rating: (review['rating'] ?? 5).round(),
                    review: reviewText,
                    reviewImages: reviewImages,
                  );
                },
              ),
              Gap(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const SocialIcon({super.key, required this.icon, required this.label});

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
