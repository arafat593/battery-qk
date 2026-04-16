import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final bool showStatus;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.showStatus = false,
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
            child: AppText(
              text: message,
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
              height: 1.4,
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
