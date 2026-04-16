import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class BusinessProfileAboutSection extends StatelessWidget {
  const BusinessProfileAboutSection({
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "About the Business",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.instance.success,
            ),
            Gap(height: 10),
            AppText(
              text:
              "Elite Home Cleaners provides premium, meticulous cleaning services tailored for Lagos' most sophisticated residents. We don't just clean; we restore your space to its original sanctuary.",
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ],
        ),
      ),
    );
  }
}