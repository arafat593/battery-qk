import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'dart:developer';

final savedBusinessProvider = StateNotifierProvider<SavedBusinessNotifier, SavedBusinessState>((ref) {
  return SavedBusinessNotifier();
});

class SavedBusinessState {
  final bool isLoading;
  final List<dynamic> savedItems;
  
  SavedBusinessState({
    this.isLoading = false,
    this.savedItems = const [],
  });

  SavedBusinessState copyWith({
    bool? isLoading,
    List<dynamic>? savedItems,
  }) {
    return SavedBusinessState(
      isLoading: isLoading ?? this.isLoading,
      savedItems: savedItems ?? this.savedItems,
    );
  }
}

class SavedBusinessNotifier extends StateNotifier<SavedBusinessState> {
  final UserRepository _userRepository = UserRepository.instance;

  SavedBusinessNotifier() : super(SavedBusinessState()) {
    fetchSavedBusinesses();
  }

  Future<void> fetchSavedBusinesses() async {
    state = state.copyWith(isLoading: true);
    try {
      var response = await _userRepository.getFavorites();
      List<dynamic> items = [];
      if (response != null && response['data'] != null) {
        if (response['data']['favorites'] is List) {
          items = response['data']['favorites'];
        } else if (response['data'] is List) {
          items = response['data'];
        }
      }
      log("Saved items fetched: ${items.length}");
      state = state.copyWith(isLoading: false, savedItems: items);
    } catch (e) {
      errorLog("fetchSavedBusinesses", e);
      state = state.copyWith(isLoading: false);
    }
  }

  void refresh() {
    fetchSavedBusinesses();
  }
  
  Future<void> removeFavorite(int favoriteId) async {
    // Optimistic UI update could be added here
    try {
      await _userRepository.deleteFavorite(favoriteId);
      // Refresh list
      fetchSavedBusinesses();
    } catch (e) {
      errorLog("removeFavorite", e);
    }
  }
}
