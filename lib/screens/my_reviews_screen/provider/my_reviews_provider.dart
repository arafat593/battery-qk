import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'dart:developer';

final myReviewsProvider = StateNotifierProvider<MyReviewsNotifier, MyReviewsState>((ref) {
  return MyReviewsNotifier();
});

class MyReviewsState {
  final bool isLoading;
  final List<dynamic> reviews;
  
  MyReviewsState({
    this.isLoading = false,
    this.reviews = const [],
  });

  MyReviewsState copyWith({
    bool? isLoading,
    List<dynamic>? reviews,
  }) {
    return MyReviewsState(
      isLoading: isLoading ?? this.isLoading,
      reviews: reviews ?? this.reviews,
    );
  }
}

class MyReviewsNotifier extends StateNotifier<MyReviewsState> {
  final UserRepository _userRepository = UserRepository.instance;

  MyReviewsNotifier() : super(MyReviewsState()) {
    fetchMyReviews();
  }

  Future<void> fetchMyReviews() async {
    state = state.copyWith(isLoading: true);
    try {
      var response = await _userRepository.getUserReviews();
      print("USER REVIEWS RESPONSE: $response");
      List<dynamic> items = [];
      if (response != null && response['data'] != null) {
        if (response['data'] is List) {
          items = response['data'];
        } else if (response['data']['reviews'] is List) {
          items = response['data']['reviews'];
        } else if (response['data']['data'] is List) {
          items = response['data']['data'];
        }
      }
      log("User reviews fetched: ${items.length}");
      state = state.copyWith(isLoading: false, reviews: items);
    } catch (e) {
      errorLog("fetchMyReviews", e);
      state = state.copyWith(isLoading: false);
    }
  }

  void refresh() {
    fetchMyReviews();
  }
}
