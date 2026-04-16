import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import 'business_profile_schedule_row.dart';

class BusinessProfileSecheduleScetion extends StatelessWidget {
  const BusinessProfileSecheduleScetion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.instance.buttonColor.withAlpha(20)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.size.height * 0.02,
          horizontal: AppSize.size.width * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Business Hours",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.instance.deepHintText,
            ),
            Gap(height: 10,),
            BusinessProfileScheduleRow(day: "Monday", time: "9:00 AM - 6:00 PM"),
            BusinessProfileScheduleRow(day: "Tuesday", time: "9:00 AM - 6:00 PM"),
            BusinessProfileScheduleRow(day: "Sunday", time: "", isClosed: true),
          ],
        ),
      ),
    );
  }
}