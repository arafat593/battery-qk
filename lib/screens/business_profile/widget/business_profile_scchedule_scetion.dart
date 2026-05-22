import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/texts/app_text.dart';
import 'business_profile_schedule_row.dart';

class BusinessProfileSecheduleScetion extends StatelessWidget {
  final List<dynamic>? businessHours;

  const BusinessProfileSecheduleScetion({
    super.key,
    this.businessHours,
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
            const Gap(height: 10),
            if (businessHours == null || businessHours!.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppText(
                  text: "Schedule not available",
                  fontSize: 14,
                  color: AppColors.instance.hintText,
                ),
              )
            else
              ...businessHours!.map((hour) {
                if (hour is! Map) return const SizedBox.shrink();
                final String label = hour['label']?.toString() ?? hour['day_label']?.toString() ?? hour['day']?.toString() ?? "";
                final bool isClosed = hour['is_closed'] == true;
                
                String timeStr = "";
                if (!isClosed) {
                  final String opens = hour['opens_at_formatted']?.toString() ?? hour['opens_at']?.toString() ?? "";
                  final String closes = hour['closes_at_formatted']?.toString() ?? hour['closes_at']?.toString() ?? "";
                  if (opens.isNotEmpty && closes.isNotEmpty) {
                    timeStr = "$opens - $closes";
                  } else {
                    timeStr = "Open";
                  }
                }
                
                return BusinessProfileScheduleRow(
                  day: label,
                  time: timeStr,
                  isClosed: isClosed,
                );
              }),
          ],
        ),
      ),
    );
  }
}