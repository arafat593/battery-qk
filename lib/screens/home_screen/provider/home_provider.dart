import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/public_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeState {
  final bool isLoading;
  final List<dynamic> businesses;
  final List<dynamic> categories;
  
  HomeState({
    this.isLoading = false,
    this.businesses = const [],
    this.categories = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    List<dynamic>? businesses,
    List<dynamic>? categories,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      businesses: businesses ?? this.businesses,
      categories: categories ?? this.categories,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState()) {
    fetchHomeData();
  }

  final PublicRepository _publicRepository = PublicRepository.instance;

  Future<void> fetchHomeData() async {
    state = state.copyWith(isLoading: true);
    try {
      var response = await _publicRepository.getHomeBusinesses();
      if (response != null && response['data'] != null) {
        // Parse your response here based on your actual API response structure
        // Assuming response['data'] is a list of businesses or contains businesses
        var data = response['data'];
        List<dynamic> loadedBusinesses = [];
        List<dynamic> loadedCategories = [];
        
        if (data is List) {
           loadedBusinesses = data;
        } else if (data is Map) {
           loadedBusinesses = data['businesses'] ?? [];
           loadedCategories = data['categories'] ?? [];
        }

        state = state.copyWith(
          isLoading: false,
          businesses: loadedBusinesses,
          categories: loadedCategories,
        );
      } else {
        AppSnackBar.instance.error("Response or data was null");
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      errorLog("fetchHomeData", e);
      AppSnackBar.instance.error("Error: $e");
      state = state.copyWith(isLoading: false);
    }
  }
}
