import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';
import '../business_profile.dart';

class BusinessProfileShareSheet extends StatelessWidget {
  const BusinessProfileShareSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const BusinessProfileShareSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.8,
      maxChildSize: 0.9,
      initialChildSize: 0.85,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Gap(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: "Share Gidira",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        radius: 18,
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 24,
                        ),
                      ),
                      const Gap(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Gidira: The Digital Curator",
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            AppText(
                              text: "Discover premium Nigerian businesses",
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    text: "SOCIAL CHANNELS",
                    fontSize: 12,
                    color: AppColors.instance.deepHintText,
                  ),
                ),
                const Gap(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SocialIcon(icon: Icons.chat, label: "WHATSAPP"),
                    SocialIcon(icon: Icons.public, label: "FACEBOOK"),
                    SocialIcon(icon: Icons.close, label: "TWITTER/X"),
                    SocialIcon(icon: Icons.camera_alt, label: "INSTAGRAM"),
                    SocialIcon(icon: Icons.work, label: "LINKEDIN"),
                  ],
                ),
                const Gap(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "DIRECT LINK",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const Gap(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "https://gidira.app/explore/curated",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            const ClipboardData(
                              text: "https://gidira.app/explore/curated",
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text("COPY LINK"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified,
                        color: Color(0xFF1E88E5),
                        size: 16,
                      ),
                      Gap(width: 6),
                      Text(
                        "CURATED FOR EXCELLENCE IN NIGERIA",
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}