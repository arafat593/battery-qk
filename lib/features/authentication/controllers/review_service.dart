import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/show_snack_bar.dart';
import '../../../data/services/eview_submit_model.dart';
import '../../../data/services/reviews_service.dart';

class ReviewController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;

  Future<void> submitReview(BuildContext context, ReviewSubmitModel review) async {
    try {
      isLoading.value = true;
      isSuccess.value = false;

      final success = await ReviewService.submitReview(review);

      if (success) {
        isSuccess.value = true;
        showSnackbar(context, "Success", "Review submitted successfully");
        Get.back(); // Close the dialog or screen
      } else {
        showSnackbar(context, "Error", "Failed to submit review.");
      }
    } catch (e) {
      showSnackbar(context, "Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
