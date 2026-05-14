import 'package:flutter/material.dart';

import '../../../constant/app_asserts_icons_path.dart';
import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';
import 'business_profile_service_item.dart';

class BusinessProfileServiceSection extends StatelessWidget {
  final List<String>? services;
  final String? category;
  
  const BusinessProfileServiceSection({
    super.key,
    this.services,
    this.category,
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
              text: category != null ? "$category Services" : "Our Services",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.instance.success,
            ),
            Gap(height: 20),
            if (services == null || services!.isEmpty)
              AppText(
                text: "No services listed.",
                fontSize: 14,
                color: AppColors.instance.hintText,
              )
            else
              ...services!.map((service) => BusinessProfileServiceItem(
                name: service,
                imagePath: AppAssertsIconsPath.instance.deepCleaning,
              )),
          ],
        ),
      ),
    );
  }
}
