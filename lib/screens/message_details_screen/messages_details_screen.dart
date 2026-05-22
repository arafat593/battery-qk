import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/screens/message_details_screen/provider/chat_details_provider.dart';
import 'package:olabisiolai_flutter_app/services/repository/chat_repository.dart';
import 'package:olabisiolai_flutter_app/screens/message_details_screen/widget/message_bubble.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

class MessagesDetailsScreen extends ConsumerStatefulWidget {
  final String? conversationUuid;
  final String chatTitle;
  final String? otherUserUuid;
  final String? avatarUrl;

  const MessagesDetailsScreen({
    super.key,
    this.conversationUuid,
    required this.chatTitle,
    this.otherUserUuid,
    this.avatarUrl,
  });

  @override
  ConsumerState<MessagesDetailsScreen> createState() => _MessagesDetailsScreenState();
}

class _MessagesDetailsScreenState extends ConsumerState<MessagesDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  String? _resolvedConversationUuid;

  String _formatLastSeen(String? lastSeenAtStr) {
    if (lastSeenAtStr == null || lastSeenAtStr.isEmpty) {
      return "OFFLINE";
    }
    try {
      final DateTime lastSeen = DateTime.parse(lastSeenAtStr).toLocal();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(lastSeen);

      if (difference.inSeconds < 60) {
        return "LAST SEEN JUST NOW";
      } else if (difference.inMinutes < 60) {
        final int minutes = difference.inMinutes;
        return "LAST SEEN $minutes ${minutes == 1 ? 'MINUTE' : 'MINUTES'} AGO";
      } else if (difference.inHours < 24) {
        final int hours = difference.inHours;
        return "LAST SEEN $hours ${hours == 1 ? 'HOUR' : 'HOURS'} AGO";
      } else if (difference.inDays < 7) {
        final int days = difference.inDays;
        return "LAST SEEN $days ${days == 1 ? 'DAY' : 'DAYS'} AGO";
      } else {
        return "LAST SEEN ${lastSeen.day}/${lastSeen.month}/${lastSeen.year}";
      }
    } catch (e) {
      return "OFFLINE";
    }
  }

  @override
  void initState() {
    super.initState();
    _resolvedConversationUuid = widget.conversationUuid;
    if (_resolvedConversationUuid == null && widget.otherUserUuid != null) {
      _loadConversationUuid();
    }
  }

  Future<void> _loadConversationUuid() async {
    if (widget.otherUserUuid == null) return;
    try {
      final response = await ChatRepository.instance.getConversations();
      if (!mounted) return;
      if (response != null && response['data'] != null) {
        List<dynamic> items = [];
        if (response['data'] is List) {
          items = response['data'];
        } else if (response['data']['conversations'] is List) {
          items = response['data']['conversations'];
        }

        String? foundUuid;
        for (var conv in items) {
          final List<dynamic>? participants = conv['participants'];
          if (participants != null) {
            for (var p in participants) {
              Map<String, dynamic>? u;
              if (p is Map) {
                if (p['user'] != null && p['user'] is Map) {
                  u = Map<String, dynamic>.from(p['user']);
                } else if (p['messageable'] != null && p['messageable'] is Map) {
                  u = Map<String, dynamic>.from(p['messageable']);
                } else if (p.containsKey('id') || p.containsKey('uuid') || p.containsKey('email') || p.containsKey('name')) {
                  u = Map<String, dynamic>.from(p);
                }
              }
              if (u != null && u['uuid']?.toString() == widget.otherUserUuid) {
                foundUuid = conv['uuid']?.toString();
                break;
              }
            }
          }
          if (foundUuid != null) break;
        }

        if (foundUuid != null) {
          if (mounted) {
            setState(() {
              _resolvedConversationUuid = foundUuid;
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading conversation UUID from backend: $e");
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedFile = null;
    });
  }

  Future<void> _handleSend(ChatDetailsNotifier notifier) async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedFile == null) return;

    _messageController.clear();
    final List<File>? files = _selectedFile != null ? [_selectedFile!] : null;
    _clearSelectedImage();

    // Call sendMessage on provider
    await notifier.sendMessage(
      text,
      files: files,
      otherUserUuid: widget.otherUserUuid,
      conversationName: widget.chatTitle,
    );

    // Scroll to bottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatDetailsProvider(_resolvedConversationUuid));
    final notifier = ref.read(chatDetailsProvider(_resolvedConversationUuid).notifier);

    final String chatTitle = (state.conversationName != null && state.conversationName!.isNotEmpty)
        ? state.conversationName!
        : widget.chatTitle;

    // Determine receiver details (avatar, online presence)
    String avatarUrl = state.conversationImageUrl ?? widget.avatarUrl ?? "";
    if (state.peer != null && state.peer is Map) {
      if (avatarUrl.isEmpty) {
        avatarUrl = state.peer!['avatar_url'] ?? "";
      }
    }
    
    bool isOnline = state.isOtherUserTyping || (state.peer != null && state.peer!['presence'] != null && state.peer!['presence']['status'] == 'online');
    final String? lastSeenAt = state.peer != null && state.peer!['presence'] != null ? state.peer!['presence']['last_seen_at']?.toString() : null;

    // Search for other participant to display presence and avatar (fallback)
    if (avatarUrl.isEmpty && state.messages.isNotEmpty) {
      // Find a message where sender is not us
      for (var msg in state.messages) {
        final sender = msg['sender'];
        if (sender != null && sender['uuid'] != state.currentUserUuid) {
          avatarUrl = sender['photo'] ?? 
              sender['image_url'] ?? 
              sender['avatar'] ?? 
              sender['logo_url'] ?? 
              sender['logo'] ?? "";
          break;
        }
      }
    }

    if (avatarUrl.isNotEmpty) {
      if (avatarUrl.contains('/storage/')) {
        final storagePath = avatarUrl.substring(avatarUrl.indexOf('/storage/'));
        avatarUrl = "${AppApiUrl.domain}$storagePath";
      } else if (!avatarUrl.startsWith('http')) {
        avatarUrl = "${AppApiUrl.domain}/storage/$avatarUrl";
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                avatarUrl.isNotEmpty
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(avatarUrl),
                      )
                    : const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFF3F4F6),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: isOnline ? Colors.green : Colors.grey,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: chatTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  AppText(
                    text: isOnline ? "ONLINE" : _formatLastSeen(lastSeenAt),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isOnline ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- Chat Messages Area ---
          Expanded(
            child: state.isLoading && state.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.messages.isEmpty
                    ? Center(
                        child: AppText(
                          text: "Send a message to start the conversation.",
                          fontSize: 14,
                          color: AppColors.instance.hintText,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true, // Latest messages at the bottom
                        padding: const EdgeInsets.all(16),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg = state.messages[index];
                          final sender = msg['sender'];
                          final bool isMe = sender != null &&
                              (sender['id'] == state.currentUserId ||
                                  sender['uuid'] == state.currentUserUuid);

                          // Parse attachment URLs
                          List<String> attachmentUrls = [];
                          final List<dynamic>? attachments = msg['attachments'];
                          if (attachments != null) {
                            for (var att in attachments) {
                              if (att is Map) {
                                String url = att['url'] ?? att['path'] ?? "";
                                if (url.isNotEmpty) {
                                  if (url.contains('/storage/')) {
                                    final storagePath = url.substring(url.indexOf('/storage/'));
                                    url = "${AppApiUrl.domain}$storagePath";
                                  } else if (!url.startsWith('http')) {
                                    url = "${AppApiUrl.domain}/storage/$url";
                                  }
                                  attachmentUrls.add(url);
                                }
                              }
                            }
                          }

                          // Time formatter
                          String timeText = "";
                          final String? createdAt = msg['created_at'];
                          if (createdAt != null) {
                            try {
                              final DateTime dt = DateTime.parse(createdAt).toLocal();
                              final int hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
                              final String minute = dt.minute.toString().padLeft(2, '0');
                              final String ampm = dt.hour >= 12 ? "PM" : "AM";
                              timeText = "$hour:$minute $ampm";
                            } catch (_) {
                              timeText = createdAt.split('T').last.substring(0, 5);
                            }
                          }

                          return MessageBubble(
                            message: msg['body'] ?? "",
                            time: timeText,
                            isMe: isMe,
                            showStatus: isMe,
                            imageUrls: attachmentUrls,
                          );
                        },
                      ),
          ),

          // Selected Image Preview Card
          if (_selectedFile != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedFile!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(width: 10),
                  const Expanded(
                    child: AppText(
                      text: "Image selected for upload",
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey),
                    onPressed: _clearSelectedImage,
                  )
                ],
              ),
            ),

          // --- Input Section ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Camera Button
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.instance.hintText.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black54,
                    ),
                    onPressed: _pickImage,
                  ),
                ),
                const Gap(width: 10),

                // Message Text Field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.instance.hintText.withAlpha(40),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppInputWidget(
                            controller: _messageController,
                            hintText: "Type message...",
                            fillColor: AppColors.instance.transparent,
                            textColor: AppColors.instance.black500,
                            border: InputBorder.none,
                            maxLines: 5,
                            onChanged: (text) {
                              notifier.setTyping(text.isNotEmpty);
                            },
                          ),
                        ),
                        const Gap(width: 4),
                        // Send/Loading Button
                        state.isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFE53935),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE53935),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () => _handleSend(notifier),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(height: 10),
        ],
      ),
    );
  }
}
