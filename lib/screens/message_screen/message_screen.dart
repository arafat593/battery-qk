import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/widget/message_heading_title.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/provider/message_provider.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  int selectedFilter = 0;

  final List<String> filters = ["All Messages", "Unread", "Verified Only"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageProvider.notifier).fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageProvider);

    // Filter conversations based on selected tab
    List<dynamic> filteredConversations = state.conversations;
    if (selectedFilter == 1) {
      // Unread
      filteredConversations = state.conversations.where((conv) {
        final dynamic rawUnread = conv['unread_count'];
        final int unreadCount = rawUnread is int
            ? rawUnread
            : (int.tryParse(rawUnread?.toString() ?? '0') ?? 0);
        return unreadCount > 0;
      }).toList();
    } else if (selectedFilter == 2) {
      // Verified Only
      filteredConversations = state.conversations.where((conv) {
        final List<dynamic>? participants = conv['participants'];
        if (participants != null && state.currentUserUuid != null) {
          for (var p in participants) {
            if (p is Map &&
                p['user'] != null &&
                p['user']['uuid'] != state.currentUserUuid) {
              final user = p['user'];
              return user['is_verified'] == true ||
                  user['shows_verified_badge'] == true;
            }
          }
        }
        return false;
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Messages", showBackButton: false),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(messageProvider.notifier).fetchConversations(),
          child: Column(
            children: [
              // Search Input Row
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size.width * 0.04,
                  vertical: 10,
                ),
                child: TextField(
                  onChanged: (val) {
                    ref.read(messageProvider.notifier).searchConversations(val);
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Search conversations...",
                    prefixIcon: const Icon(Icons.search),
                    hintStyle: const TextStyle(color: Colors.black),
                    labelStyle: const TextStyle(color: Colors.black),
                    prefixIconColor: Colors.black,
                    hoverColor: Colors.black,
                    focusColor: Colors.black,
                    suffixIconColor: Colors.black,
                    fillColor: const Color(0xFFEFEFEF),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const Gap(height: 10),

              // Filters row
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: AppSize.size.width * 0.04),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedFilter == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedFilter = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E2126)
                              : const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          text: filters[index],
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const Gap(height: 20),

              // --- Message List ---
              Expanded(
                child: state.isLoading && state.conversations.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredConversations.isEmpty
                    ? Center(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            Center(
                              child: AppText(
                                text: "No conversations found.",
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.size.width * 0.04,
                        ),
                        itemCount: filteredConversations.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 20,
                          thickness: 0.5,
                          color: Color(0xFFE5E5E5),
                        ),
                        itemBuilder: (context, index) {
                          final conv = filteredConversations[index];
                          return MessageHeadingTitle(
                            conversation: conv,
                            currentUserUuid: state.currentUserUuid,
                            currentUserId: state.currentUserId,
                            onTap: () {
                              final peer = conv['peer'];
                              String chatTitle =
                                  conv['display_name'] ??
                                  conv['conversation_name'] ??
                                  conv['name'] ??
                                  "";
                              String? avatarUrl =
                                  conv['conversation_image_url'];
                              String otherUserUuid = "";

                              if (peer != null && peer is Map) {
                                if (chatTitle.isEmpty) {
                                  chatTitle =
                                      peer['display_name'] ??
                                      peer['name'] ??
                                      "";
                                }
                                if (avatarUrl == null || avatarUrl.isEmpty) {
                                  avatarUrl = peer['avatar_url'];
                                }
                                otherUserUuid = peer['uuid']?.toString() ?? "";
                              }

                              // Find other participant name and photo to show in chat details (fallback)
                              if (chatTitle.isEmpty ||
                                  chatTitle == "Chat" ||
                                  otherUserUuid.isEmpty) {
                                final List<dynamic>? participants =
                                    conv['participants'];
                                if (participants != null) {
                                  for (var p in participants) {
                                    Map<String, dynamic>? u;
                                    if (p is Map) {
                                      if (p['user'] != null &&
                                          p['user'] is Map) {
                                        u = Map<String, dynamic>.from(
                                          p['user'],
                                        );
                                      } else if (p['messageable'] != null &&
                                          p['messageable'] is Map) {
                                        u = Map<String, dynamic>.from(
                                          p['messageable'],
                                        );
                                      } else if (p.containsKey('id') ||
                                          p.containsKey('uuid') ||
                                          p.containsKey('email') ||
                                          p.containsKey('name')) {
                                        u = Map<String, dynamic>.from(p);
                                      }
                                    }
                                    if (u != null) {
                                      final bool isMe =
                                          (state.currentUserUuid != null &&
                                              u['uuid'] ==
                                                  state.currentUserUuid) ||
                                          (state.currentUserId != null &&
                                              u['id']?.toString() ==
                                                  state.currentUserId
                                                      .toString());
                                      if (!isMe) {
                                        final name =
                                            u['display_name'] ??
                                            u['name'] ??
                                            u['full_name'];
                                        if (name != null &&
                                            name.toString().isNotEmpty) {
                                          chatTitle = name.toString();
                                        } else {
                                          final firstName =
                                              u['first_name'] ?? "";
                                          final lastName = u['last_name'] ?? "";
                                          chatTitle = "$firstName $lastName"
                                              .trim();
                                        }
                                        otherUserUuid =
                                            u['uuid']?.toString() ?? "";
                                        avatarUrl =
                                            u['avatar_url'] ??
                                            u['photo'] ??
                                            u['image_url'] ??
                                            u['avatar'] ??
                                            u['logo_url'] ??
                                            u['logo'] ??
                                            "";
                                        break;
                                      }
                                    }
                                  }
                                }
                              }
                              if (chatTitle.isEmpty) {
                                chatTitle = "Chat";
                              }

                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.messagesDetailsScreen,
                                extra: {
                                  "conversation_uuid": conv['uuid'],
                                  "chat_title": chatTitle,
                                  "other_user_uuid": otherUserUuid,
                                  "avatar_url": avatarUrl,
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
