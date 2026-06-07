import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom large title text
class CustomTitleText extends StatelessWidget {
  final String text;

  const CustomTitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
    );
  }
}

/// Custom section header text
class CustomSectionHeaderText extends StatelessWidget {
  final String text;

  const CustomSectionHeaderText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
    );
  }
}

/// Custom paragraph/body text
class CustomParagraphText extends StatelessWidget {
  final String text;

  const CustomParagraphText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class CustomSectionSubtitleText extends StatelessWidget {
  const CustomSectionSubtitleText({super.key, required this.subtitle});
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
    );
  }
}

class CustomSectionTitleText extends StatelessWidget {
  const CustomSectionTitleText({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    );
  }
}
