import 'package:batteryqk_web_app/common/widgets/custom_app_bar.dart';
import 'package:batteryqk_web_app/common/widgets/listings_details_custom/custom_details.dart';
import 'package:batteryqk_web_app/common/widgets/listings_details_custom/custom_details_image_group.dart';
import 'package:batteryqk_web_app/common/widgets/listings_details_custom/custom_listings_booking_section.dart';
import 'package:batteryqk_web_app/features/authentication/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/colors.dart';
import '../controllers/build_listing_card_controller.dart';

class ListingsDetails extends StatefulWidget {
  const ListingsDetails({
    super.key,
    required this.mainImage,
    required this.title,
    required this.location,
    required this.tag,
    required this.description,
    required this.subImage1,
    required this.subImage2,
    required this.subImage3,
    required this.subImage4,
    required this.ageGroup,
    required this.facility,
    required this.categoriesList,
    required this.openingHours,
    required this.reviews,
    required this.averageRating,
    required this.numOfReviews,
    required this.index,
    required this.gender,
    required this.discount,
  });

  final String mainImage;
  final String title;
  final String location;
  final String tag;
  final String description;
  final String subImage1;
  final String subImage2;
  final String subImage3;
  final String subImage4;
  final String ageGroup;
  final String facility;
  final List<String> categoriesList;
  final String openingHours;
  final List<Review> reviews;
  final double averageRating;
  final int numOfReviews;
  final int index;
  final String gender;
  final String discount;

  @override
  State<ListingsDetails> createState() => _ListingsDetailsState();
}

class _ListingsDetailsState extends State<ListingsDetails> {
  final List<String> contractInfos = [
    '+971527999940',
    'info.batteryqk@gmail.com',
    'www.batteryqk.com/',
  ];
  final controller = Get.find<BuildListingCardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(isBack: true),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomDetailsImageGroup(
                image1a: widget.mainImage,
                image1b: widget.subImage1,
                image1c: widget.subImage2,
                image1d: widget.subImage3,
                image1e: widget.subImage4,
              ),
              const SizedBox(height: 20),
              CustomDetails(
                name: widget.title,
                location: widget.location,
                description: widget.description,
                averageRating: widget.averageRating,
                tag: widget.tag,
                ageGroup: widget.ageGroup,
                facility: widget.facility,
                categories: widget.categoriesList,
                openingHours: widget.openingHours,
                reviews: widget.reviews,
                numOfReviews: widget.numOfReviews,
                gender: widget.gender,
                discount: widget.discount,
              ),
              CustomListingsBookingSection(
                index: widget.index,
                number: contractInfos[0],
                gmail: contractInfos[1],
                web: contractInfos[2],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
