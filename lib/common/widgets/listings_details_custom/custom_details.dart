import 'package:batteryqk_web_app/common/widgets/offer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../features/authentication/models/review_model.dart';
import '../../../features/authentication/views/review_screen.dart';
import '../../../util/colors.dart';
import '../../styles/styles.dart';
import 'custom_reviews.dart';

class CustomDetails extends StatelessWidget {
  final double averageRating; // Use double for averageRating
  final String name;
  final String location;
  final String description;
  final String tag;
  final String ageGroup;
  final String facility;
  final List<String> categories;
  final String openingHours;
  final List<Review> reviews;
  final int numOfReviews;
  final String gender;
  final String discount;

  const CustomDetails({
    super.key,
    required this.averageRating, // Pass averageRating as a double
    required this.tag,
    required this.name,
    required this.location,
    required this.description,
    required this.ageGroup,
    required this.facility,
    required this.categories,
    required this.openingHours,
    required this.reviews,
    required this.numOfReviews,
    required this.gender,
    required this.discount,
  });

  // Helper method to generate the star icons based on the average rating
  List<Widget> _buildStars() {
    List<Widget> stars = [];
    int fullStars =
        averageRating.floor(); // Full stars based on the integer part
    bool hasHalfStar =
        (averageRating - fullStars) >= 0.5; // Check if half-star is needed

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }

    // Add half star if necessary
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }

    // Add empty stars for the remaining part
    int emptyStars = 5 - stars.length; // Make sure to have 5 stars total
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: CustomTitleText(name)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    tag == "Paid".tr
                        ? Colors.blue.shade100
                        : Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'AED $tag',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Text(location, style: TextStyle(color: Colors.grey.shade600)),
        Row(
          children: [
            Row(
              children: _buildStars(), // Add star icons based on averageRating
            ),
            Text(
              ' ($averageRating)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Text(
              ('($numOfReviews ${'reviews'.tr})'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        OfferContainer(offer: discount),
        SizedBox(height: 20.h),
        CustomSectionHeaderText('description'.tr),
        CustomParagraphText(description),
        SizedBox(height: 20.h),
        CustomSectionHeaderText('age_groups'.tr),
        SizedBox(height: 5.h),
        Text(ageGroup, style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 20.h),
        CustomSectionHeaderText('gender'.tr),
        SizedBox(height: 5.h),
        Text(gender.tr, style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 20.h),
        CustomSectionHeaderText('all_sports'.tr),
        SizedBox(height: 5.h),
        Column(
          children: [
            ...List.generate(categories.length, (index) {
              return Row(
                children: [
                  const Icon(Icons.check_box, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(categories[index]),
                ],
              );
            }),
          ],
        ),
        SizedBox(height: 20.h),
        CustomSectionHeaderText('facilities'.tr),
        Row(children: [Text(facility)]),
        SizedBox(height: 20.h),
        CustomSectionHeaderText('opening_hours'.tr),
        CustomParagraphText(openingHours),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSectionHeaderText('reviews'.tr),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(reviews: reviews),
                  ),
                );
              },
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
        reviews.isEmpty
            ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'No reviews added yet',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            )
            : ListView.builder(
              shrinkWrap: true,
              itemCount: reviews.length > 2 ? 2 : reviews.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomReviews(
                    starCount: reviews[index].rating,
                    name: reviews[index].user, // Access the name here
                    designation: reviews[index].comment, // Access the comment
                  ),
                );
              },
            ),
      ],
    );
  }
}
