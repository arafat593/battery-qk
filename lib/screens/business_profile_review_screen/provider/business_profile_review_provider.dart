import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/services/repository/public_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';

final businessProfileReviewProvider = StateNotifierProvider.family<BusinessProfileReviewNotifier, BusinessProfileReviewState, int>((ref, businessId) {
  return BusinessProfileReviewNotifier(businessId);
});

class BusinessProfileReviewState {
  final bool isLoading;
  final double rating;
  final String reviewText;
  
  BusinessProfileReviewState({
    this.isLoading = false,
    this.rating = 0.0,
    this.reviewText = "",
  });

  BusinessProfileReviewState copyWith({
    bool? isLoading,
    double? rating,
    String? reviewText,
  }) {
    return BusinessProfileReviewState(
      isLoading: isLoading ?? this.isLoading,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
    );
  }
}

class BusinessProfileReviewNotifier extends StateNotifier<BusinessProfileReviewState> {
  final int businessId;
  final PublicRepository _publicRepository = PublicRepository.instance;
  final TextEditingController reviewController = TextEditingController();

  BusinessProfileReviewNotifier(this.businessId) : super(BusinessProfileReviewState()) {
    reviewController.addListener(() {
      state = state.copyWith(reviewText: reviewController.text);
    });
  }

  void updateRating(double newRating) {
    state = state.copyWith(rating: newRating);
  }

  Future<void> submitReview() async {
    if (state.rating == 0.0) {
      AppSnackBar.instance.error("Please provide a rating.");
      return;
    }
    if (state.reviewText.trim().isEmpty) {
      AppSnackBar.instance.error("Please write a review.");
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      var response = await _publicRepository.submitReview(
        businessId: businessId,
        fullName: "Anonymous", // Update based on auth state if possible
        isAnonymous: 1,
        rating: state.rating.toInt(),
        reviewText: state.reviewText,
      );

      state = state.copyWith(isLoading: false);
      
      if (response != null) {
        AppSnackBar.instance.success("Review submitted successfully.");
        AppRoutes.instance.pushReplacementNamed(
          AppRoutesKey.instance.reviewSubmittedScreen,
        );
      }
    } catch (e) {
      errorLog("submitReview", e);
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
