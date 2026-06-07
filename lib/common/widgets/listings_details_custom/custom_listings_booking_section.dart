import 'package:batteryqk_web_app/features/authentication/controllers/build_listing_card_controller.dart';
import 'package:batteryqk_web_app/features/authentication/views/BookingScreen/book_screen.dart';
import 'package:get/get.dart'; // import for .tr
import 'package:flutter/material.dart';
import '../../../util/colors.dart';
import '../custom_button.dart';

class CustomListingsBookingSection extends StatefulWidget {
  final String number;
  final String gmail;
  final String web;
  final int index;

  const CustomListingsBookingSection({
    super.key,
    required this.number,
    required this.gmail,
    required this.web,
    required this.index,
  });

  @override
  State<CustomListingsBookingSection> createState() =>
      _CustomListingsBookingSectionState();
}

class _CustomListingsBookingSectionState
    extends State<CustomListingsBookingSection> {
  DateTime? selectedDate;

  final _apiController = Get.find<BuildListingCardController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        CustomButton(
          buttonText: 'book_now'.tr,
          onPressed: () {
            Get.to(() {
              var data = _apiController.listingCardData[widget.index];
              return BookScreen(
                listingId: data.id,
                openingHours: data.operatingHours[0],
              );
            });
          },
        ),
        const SizedBox(height: 30),
        Container(height: .3, width: double.infinity, color: Colors.grey),
        const SizedBox(height: 30),
        Text('contact_information'.tr),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.phone_enabled_outlined,
                color: AppColor.blueColor,
              ),
            ),
            Text(widget.number),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.email_outlined, color: AppColor.blueColor),
            ),
            Text(widget.gmail),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.language, color: AppColor.blueColor),
            ),
            Text(widget.web),
          ],
        ),
        const SizedBox(height: 20),
        Container(height: .3, width: double.infinity, color: Colors.grey),
      ],
    );
  }
}
