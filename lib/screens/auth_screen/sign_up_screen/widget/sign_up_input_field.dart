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
  final GlobalKey<FormState> formKey;

  const SignUpInputField({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
          ),

          AppInputWidgetTwo(
            title: "Confirm Password",
            hintText: "**************",
            controller: confirmPasswordController,
            textInputAction: TextInputAction.done,
            isPassWord: true,
            maxLines: 1,
            isPassWordSecondValidation: true,
            isPassWordSecondValidationController: passwordController,
          ),

          const Gap(height: 8),
        ],
      ),
    );
  }
}
