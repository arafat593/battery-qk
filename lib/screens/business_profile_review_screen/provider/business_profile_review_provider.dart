import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/services/repository/public_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';

class BusinessReviewArgs {
  final int id;
  final String name;
  BusinessReviewArgs({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessReviewArgs &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

final businessProfileReviewProvider = StateNotifierProvider.family<BusinessProfileReviewNotifier, BusinessProfileReviewState, BusinessReviewArgs>((ref, args) {
  return BusinessProfileReviewNotifier(args.id, args.name);
});

class BusinessProfileReviewState {
  final bool isLoading;
  final double rating;
  final String reviewText;
  final List<XFile> images;
  
  BusinessProfileReviewState({
    this.isLoading = false,
    this.rating = 0.0,
    this.reviewText = "",
    this.images = const [],
  });

  BusinessProfileReviewState copyWith({
    bool? isLoading,
    double? rating,
    String? reviewText,
    List<XFile>? images,
  }) {
    return BusinessProfileReviewState(
      isLoading: isLoading ?? this.isLoading,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      images: images ?? this.images,
    );
  }
}

class BusinessProfileReviewNotifier extends StateNotifier<BusinessProfileReviewState> {
  final int businessId;
  final String businessName;
  final PublicRepository _publicRepository = PublicRepository.instance;
  final TextEditingController reviewController = TextEditingController();

  BusinessProfileReviewNotifier(this.businessId, this.businessName) : super(BusinessProfileReviewState()) {
    reviewController.addListener(() {
      state = state.copyWith(reviewText: reviewController.text);
    });
  }

  void updateRating(double newRating) {
    state = state.copyWith(rating: newRating);
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        state = state.copyWith(images: [...state.images, image]);
      }
    } catch (e) {
      errorLog("pickImage", e);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.images.length) {
      final newImages = List<XFile>.from(state.images);
      newImages.removeAt(index);
      state = state.copyWith(images: newImages);
    }
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
        images: state.images.map((e) => File(e.path)).toList(),
      );

      state = state.copyWith(isLoading: false);
      
      if (response != null) {
        AppSnackBar.instance.success("Review submitted successfully.");
        AppRoutes.instance.pushReplacementNamed(
          AppRoutesKey.instance.reviewSubmittedScreen,
          extra: {
            "business_id": businessId,
            "business_name": businessName,
            "rating": state.rating,
            "review_text": state.reviewText,
            "images": state.images.map((e) => e.path).toList(),
          },
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
