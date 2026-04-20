import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../../../constant/app_colors.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/inputs/app_input_widget.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';
import '../../../../widgets/texts/app_text.dart';

class SignUpInputField extends StatefulWidget {
  final String label;
  final String defaultCountryCode;
  final String defaultFlag;
  final Color? containerColor;
  final Color? textColor;

  const SignUpInputField({
    super.key,
    this.label = "PHONE NUMBER",
    this.defaultCountryCode = "234",
    this.defaultFlag = "🇳🇬",
    this.containerColor,
    this.textColor,
  });

  @override
  State<SignUpInputField> createState() => _SignUpInputFieldState();
}

class _SignUpInputFieldState extends State<SignUpInputField> {
  late String _countryCode;
  late String _flagEmoji;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppInputWidgetTwo(
          title: "First Name",
          hintText: "Enter your name",
        ),
        AppInputWidgetTwo(
          title: "Last Name",
          hintText: "Enter your last name",
        ),
        AppInputWidgetTwo(
          title: "Email",
          hintText: "Enter your email",
        ),
        AppInputWidgetTwo(
          title: "Phone Number*",
          hintText: "Enter your phone number",
        ),
        AppInputWidgetTwo(
          title: "Password*",
          hintText: "**************",
        ),
        AppInputWidgetTwo(
          title: "Confirm Password*",
          hintText: "**************",
        ),
        Gap(height: 8),
      ],
    );
  }
}