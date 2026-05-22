import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/app_image/app_image_circular.dart';
import '../../../widgets/texts/app_text.dart';

class MessageHeadingTitle extends StatelessWidget {
  final Function()? onTap;
  final Map<String, dynamic> conversation;
  final String? currentUserUuid;
  final int? currentUserId;

  const MessageHeadingTitle({
    super.key,
    required this.conversation,
    this.currentUserUuid,
    this.currentUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? resolveUser(dynamic p) {
      if (p is! Map) return null;
      if (p['user'] != null && p['user'] is Map) {
        return Map<String, dynamic>.from(p['user']);
      }
      if (p['messageable'] != null && p['messageable'] is Map) {
        return Map<String, dynamic>.from(p['messageable']);
      }
      if (p.containsKey('id') || p.containsKey('uuid') || p.containsKey('email') || p.containsKey('name')) {
        return Map<String, dynamic>.from(p);
      }
      return null;
    }

    // 1. Resolve Other Participant for Direct Conversations
    Map<String, dynamic>? otherParticipant;
    final peer = conversation['peer'];
    if (peer != null && peer is Map) {
      otherParticipant = Map<String, dynamic>.from(peer);
    }

    final List<dynamic>? participants = conversation['participants'];
    
    // Print to help debug API structures if needed
    debugPrint("DEBUG MessageHeadingTitle conversation ID: ${conversation['id']}, participants: $participants, currentUserUuid: $currentUserUuid, currentUserId: $currentUserId");

    if (otherParticipant == null && participants != null) {
      for (var p in participants) {
        final user = resolveUser(p);
        if (user != null) {
          final bool isMe = (currentUserUuid != null && user['uuid'] == currentUserUuid) ||
                            (currentUserId != null && user['id']?.toString() == currentUserId.toString());
          if (!isMe) {
            otherParticipant = user;
            break;
          }
        }
      }
    }
    
    // If otherParticipant is still null, fallback
    if (otherParticipant == null && participants != null && participants.isNotEmpty) {
      for (var p in participants) {
        final user = resolveUser(p);
        if (user != null) {
          final bool isMe = (currentUserUuid != null && user['uuid'] == currentUserUuid) ||
                            (currentUserId != null && user['id']?.toString() == currentUserId.toString());
          if (!isMe) {
            otherParticipant = user;
            break;
          }
        }
      }
      if (otherParticipant == null) {
        otherParticipant = resolveUser(participants.first);
      }
    }

    String displayName = conversation['display_name'] ?? conversation['conversation_name'] ?? conversation['name'] ?? "";
    if (displayName.isEmpty && otherParticipant != null) {
      final name = otherParticipant['display_name'] ?? otherParticipant['name'] ?? otherParticipant['full_name'];
      if (name != null && name.toString().isNotEmpty) {
        displayName = name.toString();
      } else {
        final firstName = otherParticipant['first_name'] ?? "";
        final lastName = otherParticipant['last_name'] ?? "";
        displayName = "$firstName $lastName".trim();
      }
    }
    if (displayName.isEmpty) {
      displayName = "Unknown User";
    }

    String avatarUrl = conversation['conversation_image_url'] ?? "";
    if (avatarUrl.isEmpty && otherParticipant != null) {
      avatarUrl = otherParticipant['avatar_url'] ?? 
          otherParticipant['photo'] ?? 
          otherParticipant['image_url'] ?? 
          otherParticipant['avatar'] ?? 
          otherParticipant['logo_url'] ?? 
          otherParticipant['logo'] ?? "";
    }
        
    if (avatarUrl.isNotEmpty) {
      if (avatarUrl.contains('/storage/')) {
        final storagePath = avatarUrl.substring(avatarUrl.indexOf('/storage/'));
        avatarUrl = "${AppApiUrl.domain}$storagePath";
      } else if (!avatarUrl.startsWith('http')) {
        avatarUrl = "${AppApiUrl.domain}/storage/$avatarUrl";
      }
    }

    final bool isVerified = conversation['is_verified'] == true ||
        otherParticipant?['is_verified'] == true || 
        otherParticipant?['shows_verified_badge'] == true;

    final lastMessageObj = conversation['last_message'];
    String lastMessageText = conversation['last_message_preview'] ?? "No messages yet";
    String timeText = "";
    
    if (lastMessageObj != null && lastMessageObj is Map) {
      lastMessageText = lastMessageObj['body'] ?? conversation['last_message_preview'] ?? "";
    }
    
    final String? createdAt = (lastMessageObj is Map ? lastMessageObj['created_at'] : null) ?? conversation['last_message_at'];
    if (createdAt != null) {
      try {
        final DateTime dt = DateTime.parse(createdAt).toLocal();
        final int hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final String minute = dt.minute.toString().padLeft(2, '0');
        final String ampm = dt.hour >= 12 ? "PM" : "AM";
        
        final now = DateTime.now();
        if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
          timeText = "$hour:$minute $ampm";
        } else {
          timeText = "${dt.day}/${dt.month}/${dt.year}";
        }
      } catch (_) {
        timeText = createdAt.split('T').first;
      }
    }

    final int unreadCount = int.tryParse(conversation['unread_count']?.toString() ?? '0') ?? 0;
    final bool hasUnread = unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(  
        padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.005),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Image with Verified Tick
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: avatarUrl.isNotEmpty
                      ? AppImageCircular(
                          url: avatarUrl,
                          width: AppSize.size.width * 0.15,
                          height: AppSize.size.width * 0.15,
                        )
                      : Container(
                          width: AppSize.size.width * 0.15,
                          height: AppSize.size.width * 0.15,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                ),
                if (isVerified)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(width: 15),
            // Name and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: displayName,
                    fontSize: AppSize.size.width * 0.042,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  const Gap(height: 4),
                  AppText(
                    text: lastMessageText,
                    fontSize: AppSize.size.width * 0.035,
                    color: Colors.grey[600],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Time and Status Dot
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: timeText,
                  fontSize: AppSize.size.width * 0.028,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                const Gap(height: 10),
                if (hasUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}