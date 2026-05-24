import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/texts/app_text.dart';

class BusinessProfileScheduleRow extends StatelessWidget {
  final String day;
  final String time;
  final bool isClosed;

  const BusinessProfileScheduleRow({
    super.key,
    required this.day,
    required this.time,
    this.isClosed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: day,
            fontSize: 14,
            color: isClosed
                ? AppColors.instance.error
                : AppColors.instance.deepHintText,
          ),
          AppText(
            text: isClosed ? "Closed" : time,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isClosed
                ? AppColors
                      .instance
                      .error // optional
                : AppColors.instance.black500,
          ),
        ],
      ),
    );
  }
}
