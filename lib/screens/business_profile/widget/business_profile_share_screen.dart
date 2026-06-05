import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessProfileShareSheet extends StatelessWidget {
  final String businessName;
  final String? logoUrl;
  final int businessId;
  final String? categoryName;

  const BusinessProfileShareSheet({
    super.key,
    required this.businessName,
    this.logoUrl,
    required this.businessId,
    this.categoryName,
  });

  static void show({
    required BuildContext context,
    required String businessName,
    String? logoUrl,
    required int businessId,
    String? categoryName,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BusinessProfileShareSheet(
        businessName: businessName,
        logoUrl: logoUrl,
        businessId: businessId,
        categoryName: categoryName,
      ),
    );
  }

  Future<void> _shareToSocial(String platform, String shareUrl) async {
    final message = "Check out $businessName on Olabisi Olai: $shareUrl";
    String url = "";
    switch (platform) {
      case "WHATSAPP":
        url =
            "https://api.whatsapp.com/send?text=${Uri.encodeComponent(message)}";
        break;
      case "FACEBOOK":
        url =
            "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareUrl)}";
        break;
      case "TWITTER/X":
        url =
            "https://twitter.com/intent/tweet?url=${Uri.encodeComponent(shareUrl)}&text=${Uri.encodeComponent("Check out $businessName on Olabisi Olai!")}";
        break;
      case "LINKEDIN":
        url =
            "https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent(shareUrl)}";
        break;
      default:
        await Clipboard.setData(ClipboardData(text: shareUrl));
        AppSnackBar.instance.success(
          "Link copied! You can now paste and share it on $platform.",
        );
        return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackBar.instance.error("Could not open $platform");
    }
  }

  @override
  Widget build(BuildContext context) {
    final shareUrl = "https://olabisiolai.com/business/$businessId";

    return DraggableScrollableSheet(
      minChildSize: 0.5,
      maxChildSize: 0.7,
      initialChildSize: 0.6,
      expand: false,
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
                    Expanded(
                      child: AppText(
                        text: "Share $businessName",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          shape: BoxShape.circle,
                          image: logoUrl != null && logoUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(logoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: logoUrl == null || logoUrl!.isEmpty
                            ? const Icon(
                                Icons.business,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                      const Gap(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: businessName,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppText(
                              text: categoryName ?? "Business Profile",
                              color: Colors.grey,
                              fontSize: 14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShareSocialIcon(
                      icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.black54, size: 24),
                      label: "WHATSAPP",
                      onTap: () => _shareToSocial("WHATSAPP", shareUrl),
                    ),
                    ShareSocialIcon( 
                      icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.black54, size: 24),
                      label: "FACEBOOK",
                      onTap: () => _shareToSocial("FACEBOOK", shareUrl),
                    ),
                    ShareSocialIcon(
                      icon: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.black54, size: 20),
                      label: "TWITTER/X",
                      onTap: () => _shareToSocial("TWITTER/X", shareUrl),
                    ),
                    ShareSocialIcon(
                      icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.black54, size: 24),
                      label: "INSTAGRAM",
                      onTap: () => _shareToSocial("INSTAGRAM", shareUrl),
                    ),
                    ShareSocialIcon(
                      icon: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.black54, size: 24),
                      label: "LINKEDIN",
                      onTap: () => _shareToSocial("LINKEDIN", shareUrl),
                    ),
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
                      Expanded(
                        child: Text(
                          shareUrl,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: shareUrl),
                          );
                          AppSnackBar.instance.success(
                            "Link copied to clipboard!",
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
                      Icon(Icons.verified, color: Color(0xFF1E88E5), size: 16),
                      Gap(width: 6),
                      Text(
                        "OLA BISI OLAI - CURATED FOR EXCELLENCE",
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

class ShareSocialIcon extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const ShareSocialIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          const Gap(height: 8),
          AppText(
            text: label,
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
