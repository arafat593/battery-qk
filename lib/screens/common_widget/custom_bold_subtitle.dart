import 'package:flutter/material.dart';
import '../../widgets/texts/app_text.dart';

class CustomBoldSubTitle extends StatelessWidget {
  final String subTitle;

  const CustomBoldSubTitle({super.key, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: subTitle,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}