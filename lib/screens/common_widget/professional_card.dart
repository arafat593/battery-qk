import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'verified_badge.dart';

//// ---------------- PROFESSIONAL CARD ----------------
class ProfessionalCard extends StatefulWidget {
  final String name;
  final double rating;
  final int reviews; 
  final String imageUrl;
  final Function()? onTap;
  final double? width; 
  final String? phone;
  final String? vendorUuid;
  final String? businessName;
  final String? logoUrl;
 
  const ProfessionalCard({
    super.key,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    this.onTap,
    this.width,
    this.phone,
    this.vendorUuid,
    this.businessName,
    this.logoUrl,
  });

  @override
  State<ProfessionalCard> createState() => _ProfessionalCardState();
}

class _ProfessionalCardState extends State<ProfessionalCard> {
  bool _isPhoneVisible = false;

  @override
  Widget build(BuildContext context) {
    final hasPhone = widget.phone != null && widget.phone!.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size.width * 0.01,
        vertical: AppSize.size.height * 0.01,
      ),
      child: Container(
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onTap,
              child: Column( 
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: AppImage(
                          url: widget.imageUrl,
                          height: 140,
                          width: widget.width ?? double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(top: 8, left: 8, child: VerifiedBadge()),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: widget.name,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.red, size: 16),
                      AppText(
                        text: " ${widget.rating} ",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      Gap(width: 4),
                      AppText(
                        text: "(${widget.reviews} reviews)",
                        fontSize: 14,
                        color: AppColors.instance.hintText,
                      ),
                    ],
                  ),
                  Gap(height: 12),
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
                  Gap(height: 8),
                  AppButton(
                    backgroundColor: AppColors.instance.buttonColor.withAlpha(
                      15,
                    ),
                    borderColor: AppColors.instance.buttonColor,
                    title: "Direct massage",
                    leadingIconImage: AppAssertsIconsPath.instance.messageIcon,
                    iconColor: AppColors.instance.buttonColor,
                    titleColor: AppColors.instance.buttonColor,
                    onTap: () {
                      if (widget.vendorUuid != null && widget.vendorUuid!.isNotEmpty) {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.messagesDetailsScreen,
                          extra: {
                            "conversation_uuid": null,
                            "chat_title": widget.businessName ?? widget.name,
                            "other_user_uuid": widget.vendorUuid,
                            "avatar_url": widget.logoUrl ?? widget.imageUrl,
                          },
                        );
                      } else {
                        AppSnackBar.instance.error(
                          "Direct messaging is not available for this vendor (Missing UUID)",
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
