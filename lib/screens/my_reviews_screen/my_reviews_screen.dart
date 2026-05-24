import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/screens/my_reviews_screen/widget/my_reviews_card_widget.dart';
import 'package:olabisiolai_flutter_app/screens/my_reviews_screen/provider/my_reviews_provider.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class MyReviewsScreen extends ConsumerStatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends ConsumerState<MyReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myReviewsProvider.notifier).fetchMyReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myReviewsProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "My Reviews"),
      body: RefreshIndicator(
        onRefresh: () => ref.read(myReviewsProvider.notifier).fetchMyReviews(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "ARCHIVE",
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.instance.blue,
                ),
                Gap(height: 12),
                AppText(
                  text: "Your Contributions",
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
                Gap(height: 12),
                AppText(
                  text:
                      "Reviewing businesses helps the Gidira community thrive and fosters growth for local creators.",
                  fontSize: 14,
                  color: AppColors.instance.hintText,
                ),
                Gap(height: 24),

                if (state.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state.reviews.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: AppText(
                        text: "You haven't submitted any reviews yet.",
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.reviews.length,
                    itemBuilder: (context, index) {
                      final review = state.reviews[index];

                      // 1. Safe Business Name Mapping
                      String businessName = "Business Name";
                      if (review['business'] != null) {
                        if (review['business'] is Map) {
                          businessName =
                              review['business']['business_name'] ??
                              review['business']['name'] ??
                              "Business Name";
                        } else {
                          businessName = review['business'].toString();
                        }
                      } else if (review['business_name'] != null) {
                        businessName = review['business_name'].toString();
                      }

                      // 2. Safe Date Mapping
                      String date = "";
                      if (review['created_at_human'] != null) {
                        date = review['created_at_human'].toString();
                      } else if (review['created_at'] != null) {
                        date = review['created_at'].toString();
                      } else if (review['date'] != null) {
                        date = review['date'].toString();
                      }

                      // 3. Safe Rating Mapping
                      int rating = 5;
                      if (review['rating'] != null) {
                        if (review['rating'] is num) {
                          rating = (review['rating'] as num).round();
                        } else {
                          rating =
                              double.tryParse(
                                review['rating'].toString(),
                              )?.round() ??
                              5;
                        }
                      }

                      // 4. Safe Review Text Mapping
                      String reviewText =
                          review['review_text'] ?? review['review'] ?? "";
                      if (reviewText.startsWith('"') &&
                          reviewText.endsWith('"') &&
                          reviewText.length > 1) {
                        reviewText = reviewText.substring(
                          1,
                          reviewText.length - 1,
                        );
                      }

                      // 5. Safe Review Images Parser
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

                      // 6. Safe Business Logo Mapping
                      String businessLogo = "";
                      if (review['business'] != null &&
                          review['business'] is Map) {
                        businessLogo =
                            review['business']['logo_url'] ??
                            review['business']['logo'] ??
                            "";
                      }
                      if (businessLogo.isEmpty) {
                        businessLogo = review['logo_url'] ?? "";
                      }
                      if (businessLogo.isNotEmpty) {
                        if (businessLogo.contains('/storage/')) {
                          final storagePath = businessLogo.substring(
                            businessLogo.indexOf('/storage/'),
                          );
                          businessLogo = "${AppApiUrl.domain}$storagePath";
                        } else if (!businessLogo.startsWith('http')) {
                          businessLogo =
                              "${AppApiUrl.domain}/storage/$businessLogo";
                        }
                      }

                      print(
                        "PARSED REVIEW IMAGES: $reviewImages for business: $businessName",
                      );

                      return MyReviewsCardWidget(
                        name: businessName,
                        date: date,
                        rating: rating,
                        review: reviewText,
                        reviewImages: reviewImages,
                        imageUrl: businessLogo,
                        editButton: () {
                          int? businessId;
                          if (review['business_id'] != null) {
                            businessId = int.tryParse(
                              review['business_id'].toString(),
                            );
                          }
                          if (businessId == null &&
                              review['business'] != null &&
                              review['business'] is Map) {
                            businessId = int.tryParse(
                              review['business']['id'].toString(),
                            );
                          }

                          if (businessId != null) {
                            AppRoutes.instance.pushNamed(
                              AppRoutesKey.instance.businessProfileReviewScreen,
                              pathParameters: {"id": businessId.toString()},
                              extra: {
                                "name": businessName,
                                "logo": businessLogo,
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                const Gap(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
