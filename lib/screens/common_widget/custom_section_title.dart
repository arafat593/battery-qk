import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class CustomSectionTitle extends StatelessWidget {
  final String title;

  const CustomSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppText(text: title, fontSize: 24, fontWeight: FontWeight.bold);
  }
}
