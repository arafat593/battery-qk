import 'package:flutter/material.dart';

import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/app_image/app_image_circular.dart';
import '../../../widgets/texts/app_text.dart';

class MessageHeadingTitle extends StatelessWidget {
  final Function()? onTap;

  const MessageHeadingTitle({super.key, required this.chat, this.onTap});

  final Map<String, dynamic> chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.size.height * 0.005),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Image with Verified Tick
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppImageCircular(
                    url: chat['image'],
                    width: AppSize.size.width * 0.15,
                    height: AppSize.size.width * 0.15,
                  ),
                ),
                if (chat['isVerified'])
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
                    text: chat['name'],
                    fontSize: AppSize.size.width * 0.042,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  const Gap(height: 4),
                  AppText(
                    text: chat['message'],
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
                  text: chat['time'],
                  fontSize: AppSize.size.width * 0.028,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                const Gap(height: 10),
                if (chat['hasUnread'])
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
