import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/chat_repository.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'dart:developer';

final messageProvider = StateNotifierProvider<MessageNotifier, MessageState>((ref) {
  return MessageNotifier();
});

class MessageState {
  final bool isLoading;
  final List<dynamic> conversations;
  final String? currentUserUuid;
  final int? currentUserId;
  final String searchQuery;

  MessageState({
    this.isLoading = false,
    this.conversations = const [],
    this.currentUserUuid,
    this.currentUserId,
    this.searchQuery = "",
  });

  MessageState copyWith({
    bool? isLoading,
    List<dynamic>? conversations,
    String? currentUserUuid,
    int? currentUserId,
    String? searchQuery,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      currentUserUuid: currentUserUuid ?? this.currentUserUuid,
      currentUserId: currentUserId ?? this.currentUserId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MessageNotifier extends StateNotifier<MessageState> {
  final ChatRepository _chatRepository = ChatRepository.instance;
  final UserRepository _userRepository = UserRepository.instance;

  MessageNotifier() : super(MessageState()) {
    init();
  }

  Future<void> init() async {
    await fetchProfile();
    await fetchConversations();
  }

  Future<void> fetchProfile() async {
    try {
      final profile = await _userRepository.getProfile();
      if (profile != null && profile['data'] != null) {
        final userData = profile['data']['user'] ?? profile['data'];
        state = state.copyWith(
          currentUserUuid: userData['uuid']?.toString(),
          currentUserId: int.tryParse(userData['id']?.toString() ?? ''),
        );
      }
    } catch (e) {
      errorLog("fetchProfile in MessageNotifier", e);
    }
  }

  Future<void> fetchConversations() async {
    if (state.conversations.isEmpty) {
      state = state.copyWith(isLoading: true);
    }
    try {
      var response = await _chatRepository.getConversations();
      List<dynamic> items = [];
      if (response != null && response['data'] != null) {
        if (response['data'] is List) {
          items = response['data'];
        } else if (response['data']['conversations'] is List) {
          items = response['data']['conversations'];
        }
      }
      state = state.copyWith(isLoading: false, conversations: items);
      log("Conversations fetched: ${items.length}");
    } catch (e) {
      errorLog("fetchConversations", e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> searchConversations(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query);
    try {
      if (query.isEmpty) {
        await fetchConversations();
        return;
      }
      var response = await _chatRepository.searchConversations(query);
      List<dynamic> items = [];
      if (response != null && response['data'] != null) {
        if (response['data'] is List) {
          items = response['data'];
        } else if (response['data']['conversations'] is List) {
          items = response['data']['conversations'];
        }
      }
      state = state.copyWith(isLoading: false, conversations: items);
    } catch (e) {
      errorLog("searchConversations", e);
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteConversation(String uuid) async {
    try {
      var success = await _chatRepository.deleteConversation(uuid);
      if (success != null) {
        // Remove from local list
        final updatedList = state.conversations.where((conv) => conv['uuid'] != uuid).toList();
        state = state.copyWith(conversations: updatedList);
      }
    } catch (e) {
      errorLog("deleteConversation in notifier", e);
    }
  }
}
