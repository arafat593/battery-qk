import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/public_repository.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

final businessProfileProvider = StateNotifierProvider.family<BusinessProfileNotifier, BusinessProfileState, int>((ref, businessId) {
  return BusinessProfileNotifier(businessId);
});

class BusinessProfileState {
  final bool isLoading;
  final dynamic businessDetails;
  final List<dynamic> reviews;
  final bool isFavorite;
  
  BusinessProfileState({
    this.isLoading = false,
    this.businessDetails,
    this.reviews = const [],
    this.isFavorite = false,
  });

  BusinessProfileState copyWith({
    bool? isLoading,
    dynamic businessDetails,
    List<dynamic>? reviews,
    bool? isFavorite,
  }) {
    return BusinessProfileState(
      isLoading: isLoading ?? this.isLoading,
      businessDetails: businessDetails ?? this.businessDetails,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class BusinessProfileNotifier extends StateNotifier<BusinessProfileState> {
  final int businessId;
  final PublicRepository _publicRepository = PublicRepository.instance;
  final UserRepository _userRepository = UserRepository.instance;

  BusinessProfileNotifier(this.businessId) : super(BusinessProfileState()) {
    fetchBusinessData();
  }

  Future<void> fetchBusinessData() async {
    state = state.copyWith(isLoading: true);
    try {
      var detailsResponse = await _publicRepository.getBusinessDetails(businessId);
      var reviewsResponse = await _publicRepository.getReviews(businessId);
      var favoriteResponse = await _userRepository.checkFavoriteExists(businessId);
      
      dynamic details;
      List<dynamic> reviewsList = [];
      bool favorite = false;

      if (detailsResponse != null && detailsResponse['data'] != null) {
        if (detailsResponse['data'] is Map && detailsResponse['data']['business'] != null) {
          details = detailsResponse['data']['business'];
        } else {
          details = detailsResponse['data'];
        }
      }
      if (reviewsResponse != null && reviewsResponse['data'] != null) {
        if (reviewsResponse['data'] is List) {
           reviewsList = reviewsResponse['data'];
        }
      }
      if (favoriteResponse != null && favoriteResponse['exists'] != null) {
         favorite = favoriteResponse['exists'];
      }

      state = state.copyWith(
        isLoading: false,
        businessDetails: details,
        reviews: reviewsList,
        isFavorite: favorite,
      );
    } catch (e) {
      errorLog("fetchBusinessData", e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleFavorite() async {
    bool currentFav = state.isFavorite;
    state = state.copyWith(isFavorite: !currentFav);
    try {
      var response = await _userRepository.toggleFavorite(businessId);
      if (response == null) {
         // revert on failure
         state = state.copyWith(isFavorite: currentFav);
      }
    } catch (e) {
      errorLog("toggleFavorite", e);
      state = state.copyWith(isFavorite: currentFav);
    }
  }
}
