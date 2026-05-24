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

  Future<void> fetchHomeData({String? search}) async {
    if (state.businesses.isEmpty && state.categories.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final results = await Future.wait([
        _publicRepository.getHomeBusinesses(search: search),
        state.categories.isEmpty
            ? _publicRepository.getCategories()
            : Future.value(null),
      ]);

      var responseHome = results[0];
      var responseCategories = results[1];

      List<dynamic> loadedBusinesses = [];
      List<dynamic> loadedCategories = List.from(state.categories);

      if (responseHome != null && responseHome['data'] != null) {
        var data = responseHome['data'];
        if (data is List) {
          loadedBusinesses = data;
        } else if (data is Map) {
          loadedBusinesses = data['businesses'] ?? [];
        }
      }

      if (responseCategories != null && responseCategories['data'] != null) {
        var catData = responseCategories['data'];
        if (catData is Map && catData['categories'] != null) {
          loadedCategories = catData['categories'];
        } else if (catData is List) {
          loadedCategories = catData;
        }
      }

      if (loadedCategories.isEmpty && loadedBusinesses.isNotEmpty) {
        final categoryMap = <int, dynamic>{};
        for (var b in loadedBusinesses) {
          if (b['category'] != null) {
            categoryMap[b['category']['id']] = b['category'];
          }
        }
        loadedCategories = categoryMap.values.toList();
      }

      state = state.copyWith(
        isLoading: false,
        businesses: loadedBusinesses,
        categories: loadedCategories,
      );
    } catch (e) {
      errorLog("fetchHomeData", e);
      AppSnackBar.instance.error("Error: $e");
      state = state.copyWith(isLoading: false);
    }
  }
}
