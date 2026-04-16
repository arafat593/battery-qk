import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';

import '../../../constant/app_asserts_icons_path.dart';
import '../../../constant/app_colors.dart';
import '../../../utils/gap.dart';
import '../../../widgets/buttons/app_button.dart';
import 'business_profile_info_row.dart';

class BusinessProfileActionSection extends StatelessWidget {
  const BusinessProfileActionSection({
    super.key,
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
              backgroundColor: AppColors.instance.error,
              borderColor: AppColors.instance.error,
              title: "Show Phone Number",
              leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
            ),
            Gap(height: 20),
            AppButton(
              backgroundColor: AppColors.instance.buttonColor,
              borderColor: AppColors.instance.buttonColor,
              title: "Show Phone Number",
              leadingIconImage: AppAssertsIconsPath.instance.messageIcon,
              iconColor: AppColors.instance.buttonColor,
            ),
            Gap(height: 20),
            AppButton(
              backgroundColor: AppColors.instance.buttonColor.withAlpha(15),
              borderColor: AppColors.instance.buttonColor,
              title: "Show Phone Number",
              leadingIconImage: AppAssertsIconsPath.instance.phoneIcon,
              titleColor: AppColors.instance.buttonColor,
              iconColor: AppColors.instance.buttonColor,
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
                  child: BusinessProfileInfoRow(
                    icon: Icons.bookmark_border,
                    text: "SAVE",
                    iconColor: AppColors.instance.hintText,
                  ),
                ),
                Expanded(
                  child: BusinessProfileInfoRow(
                    icon: Icons.language,
                    text: "WEBSITE",
                    iconColor: AppColors.instance.hintText,
                  ),
                ),
                Expanded(
                  child: BusinessProfileInfoRow(
                    icon: Icons.share,
                    text: "SHARE LISTING",
                    iconColor: AppColors.instance.hintText,
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