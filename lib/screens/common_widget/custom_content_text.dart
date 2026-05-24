import 'package:flutter/material.dart';
import '../../constant/app_colors.dart';
import '../../widgets/texts/app_text.dart';

class CustomContentText extends StatelessWidget {
  final String text;

  const CustomContentText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      fontSize: 16,
      color: AppColors.instance.deepHintText,
    );
  }
}
