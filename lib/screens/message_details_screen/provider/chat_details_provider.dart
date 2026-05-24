import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/provider/message_provider.dart';
import 'package:olabisiolai_flutter_app/services/repository/chat_repository.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

final chatDetailsProvider = StateNotifierProvider.autoDispose
    .family<ChatDetailsNotifier, ChatDetailsState, String?>((
      ref,
      conversationUuid,
    ) {
      return ChatDetailsNotifier(conversationUuid, ref);
    });

class ChatDetailsState {
  final bool isLoading;
  final List<dynamic> messages;
  final bool isSending;
  final bool isTyping;
  final String? conversationUuid;
  final int? currentUserId;
  final String? currentUserUuid;
  final bool isOtherUserTyping;
  final String? conversationName;
  final String? conversationImageUrl;
  final Map<String, dynamic>? peer;

  ChatDetailsState({
    this.isLoading = false,
    this.messages = const [],
    this.isSending = false,
    this.isTyping = false,
    this.conversationUuid,
    this.currentUserId,
    this.currentUserUuid,
    this.isOtherUserTyping = false,
    this.conversationName,
    this.conversationImageUrl,
    this.peer,
  });

  ChatDetailsState copyWith({
    bool? isLoading,
    List<dynamic>? messages,
    bool? isSending,
    bool? isTyping,
    String? conversationUuid,
    int? currentUserId,
    String? currentUserUuid,
    bool? isOtherUserTyping,
    String? conversationName,
    String? conversationImageUrl,
    Map<String, dynamic>? peer,
  }) {
    return ChatDetailsState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isTyping: isTyping ?? this.isTyping,
      conversationUuid: conversationUuid ?? this.conversationUuid,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserUuid: currentUserUuid ?? this.currentUserUuid,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      conversationName: conversationName ?? this.conversationName,
      conversationImageUrl: conversationImageUrl ?? this.conversationImageUrl,
      peer: peer ?? this.peer,
    );
  }
}

class ChatDetailsNotifier extends StateNotifier<ChatDetailsState> {
  final ChatRepository _chatRepository = ChatRepository.instance;
  final UserRepository _userRepository = UserRepository.instance;
  final Ref ref;
  Timer? _pollingTimer;
  Timer? _typingTimer;

  ChatDetailsNotifier(String? conversationUuid, this.ref)
    : super(ChatDetailsState(conversationUuid: conversationUuid)) {
    init();
  }

  Future<void> init() async {
    await fetchProfile();
    if (!mounted) return;
    if (state.conversationUuid != null && state.conversationUuid!.isNotEmpty) {
      await fetchMessages();
      _startPolling();
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (state.conversationUuid != null &&
          state.conversationUuid!.isNotEmpty) {
        fetchMessages(background: true);
      }
    });
  }

  Future<void> fetchProfile() async {
    try {
      final profile = await _userRepository.getProfile();
      if (!mounted) return;
      if (profile != null && profile['data'] != null) {
        final userData = profile['data']['user'] ?? profile['data'];
        state = state.copyWith(
          currentUserUuid: userData['uuid']?.toString(),
          currentUserId: int.tryParse(userData['id']?.toString() ?? ''),
        );
      }
    } catch (e) {
      errorLog("fetchProfile in ChatDetailsNotifier", e);
    }
  }

  Future<void> fetchMessages({bool background = false}) async {
    if (!background) {
      state = state.copyWith(isLoading: true);
    }
    try {
      final uuid = state.conversationUuid;
      if (uuid == null || uuid.isEmpty) return;

      var response = await _chatRepository.getMessages(uuid);
      if (!mounted) return;
      List<dynamic> items = [];
      String? convName;
      String? convImageUrl;
      Map<String, dynamic>? peerData;
      if (response != null && response['data'] != null) {
        if (response['data'] is List) {
          items = response['data'];
        } else if (response['data'] is Map) {
          if (response['data']['messages'] is List) {
            items = response['data']['messages'];
          }
          convName =
              response['data']['display_name']?.toString() ??
              response['data']['conversation_name']?.toString();
          convImageUrl = response['data']['conversation_image_url']?.toString();
          if (response['data']['peer'] is Map) {
            peerData = Map<String, dynamic>.from(response['data']['peer']);
          }
        }
      }

      state = state.copyWith(
        isLoading: false,
        messages: items,
        conversationName: convName,
        conversationImageUrl: convImageUrl,
        peer: peerData,
      );

      // Auto mark unread messages as read
      for (var msg in items) {
        final List<dynamic>? readBy = msg['read_by'];
        final sender = msg['sender'];
        final bool isMe =
            sender != null &&
            (sender['id'] == state.currentUserId ||
                sender['uuid'] == state.currentUserUuid);

        if (!isMe &&
            (readBy == null || !readBy.contains(state.currentUserId))) {
          final String? msgUuid = msg['uuid'];
          if (msgUuid != null) {
            _chatRepository.readMessage(msgUuid);
          }
        }
      }
    } catch (e) {
      errorLog("fetchMessages", e);
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// Create a conversation dynamically (if starting chat from business profile page)
  Future<String?> createConversation(
    String otherUserUuid, {
    String? name,
  }) async {
    try {
      var response = await _chatRepository.createConversation(
        otherUserUuid,
        name: name,
      );
      if (!mounted) return null;
      if (response != null && response['data'] != null) {
        final convData = response['data'];
        final String newUuid = convData['uuid'];
        state = state.copyWith(conversationUuid: newUuid);

        // Refresh conversations list
        ref.read(messageProvider.notifier).fetchConversations();

        _startPolling();
        return newUuid;
      }
    } catch (e) {
      errorLog("createConversation in ChatDetailsNotifier", e);
    }
    return null;
  }

  /// Send message
  Future<bool> sendMessage(
    String text, {
    List<File>? files,
    String? otherUserUuid,
    String? conversationName,
  }) async {
    if (text.trim().isEmpty && (files == null || files.isEmpty)) return false;

    state = state.copyWith(isSending: true);
    try {
      String? uuid = state.conversationUuid;

      // 1. If conversation doesn't exist, create it first
      if ((uuid == null || uuid.isEmpty) && otherUserUuid != null) {
        uuid = await createConversation(otherUserUuid, name: conversationName);
        if (!mounted) return false;
      }

      if (uuid == null || uuid.isEmpty) {
        if (mounted) {
          state = state.copyWith(isSending: false);
        }
        return false;
      }

      // 2. Upload attachments if any
      List<dynamic> attachmentIds = [];
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          final response = await _chatRepository.uploadAttachment(file);
          if (!mounted) return false;
          if (response != null && response['data'] != null) {
            final dynamic attId =
                response['data']['id'] ??
                response['data']['uuid'];
            if (attId != null) {
              attachmentIds.add(attId);
            }
          }
        }
      }

      // 3. Send message
      final response = await _chatRepository.sendMessage(
        uuid,
        text,
        attachmentIds: attachmentIds,
      );
      if (!mounted) return false;
      if (response != null && response['data'] != null) {
        // Append new message locally for instant update
        final currentMessages = List.from(state.messages);
        currentMessages.insert(
          0,
          response['data'],
        ); // insert at the top (latest message)
        state = state.copyWith(messages: currentMessages);
        state = state.copyWith(isSending: false);

        // Stop typing indicator on send
        setTyping(false);
        return true;
      }
    } catch (e) {
      errorLog("sendMessage in notifier", e);
    }
    if (mounted) {
      state = state.copyWith(isSending: false);
    }
    return false;
  }

  /// Update/Edit message
  Future<bool> editMessage(String messageUuid, String newBody) async {
    try {
      var response = await _chatRepository.updateMessage(messageUuid, newBody);
      if (!mounted) return false;
      if (response != null && response['data'] != null) {
        final updatedMsg = response['data'];
        final updatedList = state.messages.map((msg) {
          if (msg['uuid'] == messageUuid) {
            return updatedMsg;
          }
          return msg;
        }).toList();
        state = state.copyWith(messages: updatedList);
        return true;
      }
    } catch (e) {
      errorLog("editMessage in notifier", e);
    }
    return false;
  }

  /// Delete message
  Future<bool> deleteMessage(String messageUuid) async {
    try {
      var response = await _chatRepository.deleteMessage(messageUuid);
      if (!mounted) return false;
      if (response != null) {
        final updatedList = state.messages
            .where((msg) => msg['uuid'] != messageUuid)
            .toList();
        state = state.copyWith(messages: updatedList);
        return true;
      }
    } catch (e) {
      errorLog("deleteMessage in notifier", e);
    }
    return false;
  }

  /// Send typing status to backend
  void setTyping(bool isTyping) {
    if (state.conversationUuid == null || state.conversationUuid!.isEmpty)
      return;

    if (state.isTyping == isTyping) return;
    state = state.copyWith(isTyping: isTyping);

    _chatRepository.setTypingStatus(state.conversationUuid!, isTyping);

    // If typing is true, set a timer to automatically set it to false after 3 seconds of inactivity
    if (isTyping) {
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        setTyping(false);
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }
}
