

import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget_tow.dart';

class SignUpInputField extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpInputField({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppInputWidgetTwo(
          title: "First Name",
          hintText: "Enter your name",
          controller: firstNameController,
          textInputAction: TextInputAction.next,
          validator: (value) =>
          value!.trim().isEmpty ? "Enter your first name" : null,
        ),

        AppInputWidgetTwo(
          title: "Last Name",
          hintText: "Enter your last name",
          controller: lastNameController,
          textInputAction: TextInputAction.next,
          validator: (value) =>
          value!.trim().isEmpty ? "Enter your last name" : null,
        ),

        AppInputWidgetTwo(
          title: "Email",
          hintText: "Enter your email",
          controller: emailController,
          // isEmail: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) =>
          value!.trim().isEmpty ? "Enter your email" : null,
        ),

        AppInputWidgetTwo(
          title: "Phone Number",
          hintText: "Enter your phone number",
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) =>
          value!.trim().isEmpty ? "Enter your phone number" : null,
        ),

        AppInputWidgetTwo(
          title: "Password",
          hintText: "**************",
          controller: passwordController,
          textInputAction: TextInputAction.next,
          isPassWord: true,
          maxLines: 1,
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

        AppInputWidgetTwo(
          title: "Confirm Password",
          hintText: "**************",
          controller: confirmPasswordController,
          textInputAction: TextInputAction.done,
          isPassWord: true,
          maxLines: 1,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return "Enter your password";
            }
            if ((value ?? '').length < 6) {
              return "At least 6 characters";
            }
            if (value != passwordController.text) {
              return "Password does not match";
            }
            return null;
          },
        ),

        const Gap(height: 8),
      ],
    );
  }
}