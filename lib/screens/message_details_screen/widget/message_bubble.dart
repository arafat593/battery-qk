import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final bool showStatus;
  final List<String>? imageUrls;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.showStatus = false,
    this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: AppSize.size.width * 0.75),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF1E2128) : const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrls != null && imageUrls!.isNotEmpty) ...[
                  ...imageUrls!.map((url) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          width: AppSize.size.width * 0.6,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: AppSize.size.width * 0.6,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
                if (message.isNotEmpty)
                  AppText(
                    text: message,
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 16,
                    height: 1.4,
                  ),
              ],
            ),
          ),
          const Gap(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              if (showStatus) ...[
                const Gap(width: 4),
                const Icon(Icons.done_all, color: Colors.red, size: 14),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
