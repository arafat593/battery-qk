import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/services/repository/public_repository.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
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
  final bool isAnonymous;
  
  BusinessProfileReviewState({
    this.isLoading = false,
    this.rating = 0.0,
    this.reviewText = "",
    this.images = const [],
    this.isAnonymous = false,
  });

  BusinessProfileReviewState copyWith({
    bool? isLoading,
    double? rating,
    String? reviewText,
    List<XFile>? images,
    bool? isAnonymous,
  }) {
    return BusinessProfileReviewState(
      isLoading: isLoading ?? this.isLoading,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      images: images ?? this.images,
      isAnonymous: isAnonymous ?? this.isAnonymous,
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

  void toggleAnonymous() {
    state = state.copyWith(isAnonymous: !state.isAnonymous);
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> selectedImages = await picker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        state = state.copyWith(images: [...state.images, ...selectedImages]);
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
      String fullName = "Anonymous";
      if (!state.isAnonymous) {
        try {
          var localData = await StorageServices.instance.getLogDedData();
          fullName = localData["name"] ?? "${localData["first_name"] ?? ""} ${localData["last_name"] ?? ""}".trim();
          if (fullName.isEmpty) {
            fullName = "User";
          }
        } catch (e) {
          fullName = "User";
        }
      }

      var response = await _publicRepository.submitReview(
        businessId: businessId,
        fullName: fullName,
        isAnonymous: state.isAnonymous ? 1 : 0,
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
