import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/listings_details_custom/build_listing_card.dart';
import '../../../../../util/colors.dart';
import '../../../controllers/build_listing_card_controller.dart';
import '../../BookingScreen/book_screen.dart';
import '../../ListingScreen/listings.dart';
import '../../listings_details.dart';

class TopListingsSection extends StatelessWidget {
  final BuildListingCardController apiController;
  const TopListingsSection({required this.apiController, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "top_listings".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff212121),
                ),
              ),
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Listings(isBack: true,)),
                    ),
                child: Text(
                  "view_all".tr,
                  style: TextStyle(
                    color: AppColor.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          ...List.generate(
            apiController.listingCardData.length > 3
                ? 3
                : apiController.listingCardData.length,
            (index) {
              final data = apiController.listingCardData[index];
              return BuildListingCard(
                context: context,
                title: data.name,
                location: '${data.mainFeatures} | ${data.location}',
                tag: data.price,
                // rating: 4.5,
                description: data.description,
                imageUrl: data.mainImage,
                averageRating: data.averageRating,
                discount: data.discount,
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ListingsDetails(
                              mainImage: data.mainImage,
                              description: data.description,
                              location:
                                  '${data.mainFeatures} | ${data.location}',
                              tag: data.price,
                              title: data.name,
                              subImage1: data.subImage1,
                              subImage2: data.subImage2,
                              subImage3: data.subImage3,
                              subImage4: data.subImage4,
                              ageGroup: data.ageGroup[0],
                              facility: data.facilities[0],
                              categoriesList:
                                  apiController
                                      .listingCardData[0]
                                      .specificItemNames,
                              openingHours: data.operatingHours[0],
                              reviews: data.reviews,
                              averageRating: data.averageRating,
                              numOfReviews: data.totalReviews,
                              index: index,
                              gender: data.gender,
                              discount: data.discount,
                            ),
                      ),
                    ),
                bookingOnPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BookScreen(
                              listingId: data.id,
                              openingHours: data.operatingHours[0],
                            ),
                      ),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
