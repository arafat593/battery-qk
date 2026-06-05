import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/chat_repository.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'dart:developer';

final messageProvider = StateNotifierProvider.autoDispose<MessageNotifier, MessageState>((
  ref,
) {
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
  Timer? _pollingTimer;

  MessageNotifier() : super(MessageState()) {
    init();
  }

  Future<void> init() async {
    final token = await StorageServices.instance.getToken();
    if (token.isEmpty) {
      log("MessageNotifier init: No token, skipping initial fetch");
      return;
    }
    await fetchProfile();
    await fetchConversations();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final token = await StorageServices.instance.getToken();
      if (token.isEmpty) {
        timer.cancel();
        return;
      }
      if (state.searchQuery.isEmpty) {
        fetchConversations(background: true);
      }
    });
  }

  Future<void> fetchProfile() async {
    final token = await StorageServices.instance.getToken();
    if (token.isEmpty) return;
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

  Future<void> fetchConversations({bool background = false}) async {
    final token = await StorageServices.instance.getToken();
    if (token.isEmpty) {
      log("MessageNotifier fetchConversations: No token, aborting request");
      return;
    }
    if (state.conversations.isEmpty && !background) {
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
      if (mounted) {
        state = state.copyWith(isLoading: false, conversations: items);
      }
      log("Conversations fetched: ${items.length}");
    } catch (e) {
      errorLog("fetchConversations", e);
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
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
      if (mounted) {
        state = state.copyWith(isLoading: false, conversations: items);
      }
    } catch (e) {
      errorLog("searchConversations", e);
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  void markConversationAsRead(String conversationUuid) {
    if (state.conversations.isEmpty) return;
    final updatedList = state.conversations.map((conv) {
      if (conv['uuid'] == conversationUuid) {
        final updatedConv = Map<String, dynamic>.from(conv);
        updatedConv['unread_count'] = 0;
        return updatedConv;
      }
      return conv;
    }).toList();
    state = state.copyWith(conversations: updatedList);
  }

  Future<void> deleteConversation(String uuid) async {
    try {
      var success = await _chatRepository.deleteConversation(uuid);
      if (success != null) {
        // Remove from local list
        final updatedList = state.conversations
            .where((conv) => conv['uuid'] != uuid)
            .toList();
        state = state.copyWith(conversations: updatedList);
      }
    } catch (e) {
      errorLog("deleteConversation in notifier", e);
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
