import 'package:flutter/material.dart';
import '../../../../utils/gap.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';

class PhoneInputField extends StatefulWidget {
  final Color? containerColor;
  final Color? textColor;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const PhoneInputField({
    super.key,

    this.containerColor,
    this.textColor,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppInputWidgetTwo(
          validator: (String? value){
            if(value?.isEmpty == true){
              return "Enter your email";
            }
            return null;
          },
          title: "phone number/email",
          controller: widget.emailController,
          textInputAction: TextInputAction.next,
        ),
        AppInputWidgetTwo(
          title: "Password",
          controller: widget.passwordController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          maxLines: 1,
          isPassWord: true,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return "Enter your password";
            }
            if ((value ?? '').length < 6) {
              return "At least 6 characters";
            }
            return null;
          },
        ),
        Gap(height: 8),
      ],
    );
  }
}
