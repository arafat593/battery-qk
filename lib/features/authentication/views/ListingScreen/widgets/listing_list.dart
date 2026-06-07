import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/listings_details_custom/build_listing_card.dart';
import '../../../controllers/build_listing_card_controller.dart';
import '../../BookingScreen/book_screen.dart';
import '../../listings_details.dart';

class ListingsList extends StatelessWidget {
  final BuildListingCardController listController;
  const ListingsList({super.key, required this.listController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          // ✅ added Obx
          itemCount: listController.filteredListingData.length,
          itemBuilder: (context, index) {
            var data = listController.filteredListingData[index];
            var ageGroup = data.ageGroup[0];
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ListingsDetails(
                          mainImage: data.mainImage,
                          title: data.name,
                          location: data.location,
                          tag: data.price,
                          description: data.description,
                          subImage1: data.subImage1,
                          subImage2: data.subImage2,
                          subImage3: data.subImage3,
                          subImage4: data.subImage4,
                          ageGroup: ageGroup,
                          facility: data.facilities[0],
                          categoriesList:
                              listController
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
                );
              },
              bookingOnPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BookScreen(
                          listingId: data.id,
                          openingHours: data.operatingHours[0],
                        ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
