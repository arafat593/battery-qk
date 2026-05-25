import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'business_profile_info_row.dart';

class BusinessProfileActionSection extends StatelessWidget {
  final String? phone;
  final String? whatsapp;
  final String? website;
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
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onShareTap,
    this.vendorUuid,
    this.businessName = "Chat",
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
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
              backgroundColor: (phone != null && phone!.trim().isNotEmpty)
                  ? AppColors.instance.error
                  : AppColors.instance.hintText.withAlpha(50),
              borderColor: (phone != null && phone!.trim().isNotEmpty)
                  ? AppColors.instance.error
                  : AppColors.instance.hintText.withAlpha(50),
              title: (phone != null && phone!.trim().isNotEmpty)
                  ? phone!
                  : "Phone Not Available",
              titleColor: (phone != null && phone!.trim().isNotEmpty)
                  ? Colors.white
                  : AppColors.instance.hintText,
              iconColor: (phone != null && phone!.trim().isNotEmpty)
                  ? Colors.white
                  : AppColors.instance.hintText,
              leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
              onTap: (phone != null && phone!.trim().isNotEmpty)
                  ? () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: phone!.trim(),
                      );
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {
                        AppSnackBar.instance.error(
                          "Could not launch phone dialer",
                        );
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
                if (vendorUuid != null && vendorUuid!.isNotEmpty) {
                  AppRoutes.instance.pushNamed(
                    AppRoutesKey.instance.messagesDetailsScreen,
                    extra: {
                      "conversation_uuid": null,
                      "chat_title": businessName,
                      "other_user_uuid": vendorUuid,
                      "avatar_url": logoUrl,
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
              backgroundColor: (whatsapp != null && whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor.withAlpha(15)
                  : AppColors.instance.hintText.withAlpha(20),
              borderColor: (whatsapp != null && whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor
                  : AppColors.instance.hintText,
              title: (whatsapp != null && whatsapp!.trim().isNotEmpty)
                  ? "Chat Via WhatsApp"
                  : "WhatsApp Not Available",
              leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
              titleColor: (whatsapp != null && whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor
                  : AppColors.instance.hintText,
              iconColor: (whatsapp != null && whatsapp!.trim().isNotEmpty)
                  ? AppColors.instance.buttonColor
                  : AppColors.instance.hintText,
              onTap: (whatsapp != null && whatsapp!.trim().isNotEmpty)
                  ? () async {
                      final cleanNumber = whatsapp!.replaceAll(
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
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: BusinessProfileInfoRow(
                      icon: isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      text: isFavorite ? "SAVED" : "SAVE",
                      iconColor: isFavorite
                          ? AppColors.instance.buttonColor
                          : AppColors.instance.hintText,
                      textColor: isFavorite
                          ? AppColors.instance.buttonColor
                          : AppColors.instance.hintText,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (website != null && website!.trim().isNotEmpty)
                        ? () async {
                            var urlString = website!.trim();
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
                          }
                        : () {
                            AppSnackBar.instance.error("Website not available");
                          },
                    child: BusinessProfileInfoRow(
                      icon: Icons.language,
                      text: "WEBSITE",
                      iconColor: (website != null && website!.trim().isNotEmpty)
                          ? AppColors.instance.buttonColor
                          : AppColors.instance.hintText,
                      textColor: (website != null && website!.trim().isNotEmpty)
                          ? AppColors.instance.buttonColor
                          : AppColors.instance.hintText,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onShareTap,
                    child: BusinessProfileInfoRow(
                      icon: Icons.share,
                      text: "SHARE LISTING",
                      iconColor: AppColors.instance.hintText,
                    ),
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
