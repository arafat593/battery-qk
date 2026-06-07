import 'package:batteryqk_web_app/data/services/api_services.dart';
import 'package:batteryqk_web_app/features/authentication/controllers/icon_controller.dart';
import 'package:batteryqk_web_app/features/authentication/controllers/review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../features/authentication/controllers/booking_history_controller.dart';
import '../../util/colors.dart';
import '../styles/styles.dart';
import 'custom_review_icon.dart';
import 'icon_text_button.dart';
import 'show_snack_bar.dart';

class ReviewDialog extends StatelessWidget {
  ReviewDialog({
    super.key,
    required this.academyName,
    required this.bookingId,
    required this.reviewController,
  });

  final String academyName;
  final int bookingId;
  final TextEditingController reviewController;

  final ReviewController reviewCtrl = Get.put(ReviewController());
  final IconController iconController = Get.find<IconController>();
  final ApiService apiServices = ApiService();
  final BookingHistoryController bookingController =
      Get.find<BookingHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.whiteColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: CustomTitleText('write_review_title'.tr)),
              SizedBox(height: 10.h),
              Center(child: CustomSectionTitleText(title: academyName)),
              Center(
                child: CustomSectionSubtitleText(
                  subtitle: 'share_experience_subtitle'.tr,
                ),
              ),
              SizedBox(height: 10.h),
              CustomSectionHeaderText('rating_header'.tr),
              CustomReviewIcons(tappable: true),
              SizedBox(height: 10.h),

              CustomSectionHeaderText('your_review_header'.tr),
              SizedBox(height: 10.h),
              TextField(
                controller: reviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'review_hint'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              /// Submit Button
              IconTextButton(
                onPressed: () {
                  if (reviewController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('review_empty_error'.tr),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (iconController.selectedIndex.value == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('review_empty_error'.tr),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Submit the review
                    apiServices
                        .sendReview(
                          bookingId,
                          iconController.selectedIndex.value,
                          reviewController.text,
                        )
                        .then((_) {
                          // Call fetchBooking() to refresh data
                          bookingController.fetchBooking();
                          // Show success message on successful submission
                          showSnackbar(
                            context,
                            'review_success_title'.tr,
                            'review_success'.tr,
                          );
                          // Clear the form and reset the state
                          iconController.selectedIndex.value = 0;
                          reviewController.clear();
                          Navigator.pop(context);
                        })
                        .catchError((error) {
                          // Handle any error if the submission fails
                          showSnackbar(
                            context,
                            'review_error_title'.tr,
                            '${'review_error_message'.tr} $error',
                          );
                        });
                  }
                },
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                text: 'submit_review_button'.tr,
              ),

              SizedBox(height: 10.h),

              /// Cancel Button
              IconTextButton(
                onPressed: () {
                  iconController.selectedIndex.value = 0;
                  reviewController.clear();
                  Navigator.pop(context);
                },
                text: 'cancel_button'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
