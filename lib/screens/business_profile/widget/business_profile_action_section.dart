import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'business_profile_info_row.dart';

class BusinessProfileActionSection extends StatefulWidget {
  final String? phone;
  final String? whatsapp;
  final String? website;
  final String? instagramUrl;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onShareTap;
  final String? vendorUuid;
  final String businessName;
  final String? logoUrl;
 
  const BusinessProfileActionSection({
    super.key,
    this.phone,
    this.whatsapp,
    this.website,
    this.instagramUrl,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onShareTap,
    this.vendorUuid,
    this.businessName = "Chat",
    this.logoUrl,
  });

  @override
  State<BusinessProfileActionSection> createState() => _BusinessProfileActionSectionState();
}

class _BusinessProfileActionSectionState extends State<BusinessProfileActionSection> {
  bool _isPhoneVisible = false;

  @override
  Widget build(BuildContext context) {
    final hasPhone = widget.phone != null && widget.phone!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.size.height * 0.02,
          horizontal: AppSize.size.width * 0.04,
        ),
        child: Column(
          children: [
            // 3. Action Buttons Section
            AppButton(
              backgroundColor: hasPhone
                  ? AppColors.instance.error
                  : AppColors.instance.hintText.withAlpha(50),
              borderColor: hasPhone
                  ? AppColors.instance.error
                  : AppColors.instance.hintText.withAlpha(50),
              title: hasPhone
                  ? (_isPhoneVisible ? widget.phone! : "Show phone number")
                  : "Phone Not Available",
              titleColor: hasPhone
                  ? Colors.white
                  : AppColors.instance.hintText, 
              iconColor: hasPhone
                  ? Colors.white
                  : AppColors.instance.hintText,
              leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
              onTap: hasPhone
                  ? () async {
                      if (!_isPhoneVisible) {
                        setState(() {
                          _isPhoneVisible = true;
                        });
                      } else {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: widget.phone!.trim(),
                        );
                        if (await canLaunchUrl(launchUri)) {
                          await launchUrl(launchUri);
                        } else {
                          AppSnackBar.instance.error(
                            "Could not launch phone dialer",
                          );
                        }
                      }
                    }
                  : () {
                      AppSnackBar.instance.error("Phone number not available");
                    },
            ),
            Gap(height: 20),
            AppButton(
              backgroundColor: AppColors.instance.buttonColor,
              borderColor: AppColors.instance.buttonColor,
              title: "Direct massage",
              leadingIconImage: AppAssertsIconsPath.instance.messageIcon,
              iconColor: AppColors.instance.buttonColor,
              onTap: () {
                if (widget.vendorUuid != null && widget.vendorUuid!.isNotEmpty) {
                  AppRoutes.instance.pushNamed(
                    AppRoutesKey.instance.messagesDetailsScreen,
                    extra: {
                      "conversation_uuid": null,
                      "chat_title": widget.businessName,
                      "other_user_uuid": widget.vendorUuid,
                      "avatar_url": widget.logoUrl, 
                    },
                  );
                } else {
                  AppSnackBar.instance.error(
                    "Direct messaging is not available for this vendor (Missing UUID)",
                  );
                } 
              },
            ),
            Gap(height: 20),
            AppButton(
              backgroundColor: (widget.whatsapp != null && widget.whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor.withAlpha(15)
                  : AppColors.instance.hintText.withAlpha(20),
              borderColor: (widget.whatsapp != null && widget.whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor
                  : AppColors.instance.hintText,
              title: (widget.whatsapp != null && widget.whatsapp!.trim().isNotEmpty)
                  ? "Chat Via WhatsApp"
                  : "WhatsApp Not Available",
              leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
              titleColor: (widget.whatsapp != null && widget.whatsapp!.trim().isNotEmpty) 
                  ? AppColors.instance.buttonColor
                  : AppColors.instance.hintText,
              iconColor: (widget.whatsapp != null && widget.whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor
                  : AppColors.instance.hintText,
              onTap: (widget.whatsapp != null && widget.whatsapp!.trim().isNotEmpty)
                  ? () async {
                      final cleanNumber = widget.whatsapp!.replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );
                      final Uri whatsappUri = Uri.parse(
                        "https://wa.me/$cleanNumber",
                      );
                      if (await canLaunchUrl(whatsappUri)) {
                        await launchUrl(
                          whatsappUri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        AppSnackBar.instance.error("Could not launch WhatsApp");
                      }
                    }
                  : () {
                      AppSnackBar.instance.error(
                        "WhatsApp number not available",
                      );
                    },
            ),
 
            Gap(height: 30),
            BusinessProfileInfoRow(
              icon: Icons.av_timer_outlined,
              text: "Usually responds within 15 mins",
              iconColor: AppColors.instance.hintText,
            ),
            BusinessProfileInfoRow(
              icon: Icons.check_circle_outline_outlined,
              text: "Secure transaction protection",
              iconColor: AppColors.instance.hintText,
            ),
            Gap(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _ActionVerticalButton(
                    onTap: widget.onFavoriteTap ?? () {},
                    icon: Icon(
                      widget.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: widget.isFavorite
                          ? AppColors.instance.buttonColor
                          : AppColors.instance.hintText,
                      size: 24,
                    ),
                    label: widget.isFavorite ? "SAVED" : "SAVE",
                    color: widget.isFavorite
                        ? AppColors.instance.buttonColor
                        : AppColors.instance.hintText,
                  ),
                ),
                if (widget.website != null && widget.website!.trim().isNotEmpty)
                  Expanded(
                    child: _ActionVerticalButton(
                      onTap: () async {
                        var urlString = widget.website!.trim();
                        if (!urlString.startsWith('http://') &&
                            !urlString.startsWith('https://')) {
                          urlString = 'https://$urlString';
                        }
                        final Uri uri = Uri.parse(urlString);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          AppSnackBar.instance.error(
                            "Could not open website",
                          );
                        }
                      },
                      icon: Icon(
                        Icons.language,
                        color: AppColors.instance.buttonColor,
                        size: 24,
                      ),
                      label: "WEBSITE",
                      color: AppColors.instance.buttonColor,
                    ),
                  ),
                if (widget.instagramUrl != null && widget.instagramUrl!.trim().isNotEmpty)
                  Expanded(
                    child: _ActionVerticalButton(
                      onTap: () async {
                        var urlString = widget.instagramUrl!.trim();
                        if (urlString.startsWith('@')) {
                          urlString = 'https://instagram.com/${urlString.substring(1)}';
                        } else if (!urlString.startsWith('http://') &&
                            !urlString.startsWith('https://')) {
                          urlString = 'https://instagram.com/$urlString';
                        }
                        final Uri uri = Uri.parse(urlString);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          AppSnackBar.instance.error(
                            "Could not open Instagram",
                          );
                        }
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: AppColors.instance.buttonColor,
                        size: 24,
                      ),
                      label: "INSTAGRAM",
                      color: AppColors.instance.buttonColor,
                    ),
                  ),
                Expanded(
                  child: _ActionVerticalButton(
                    onTap: widget.onShareTap ?? () {},
                    icon: Icon(
                      Icons.share,
                      color: AppColors.instance.hintText,
                      size: 24,
                    ),
                    label: "SHARE",
                    color: AppColors.instance.hintText,
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

class _ActionVerticalButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionVerticalButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon,
            ),
          ),
          const Gap(height: 6),
          AppText(
            text: label,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
