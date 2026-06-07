import 'package:batteryqk_web_app/features/authentication/views/reset_password_screen.dart';
import 'package:batteryqk_web_app/features/authentication/views/signup_screen.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common/widgets/built_social_button.dart';
import '../../../common/widgets/custom_text_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text(
                'Pin Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(30),
                    // Curve edges for circular look
                    fieldHeight: 45,
                    fieldWidth: 45,
                    inactiveColor: Colors.grey,
                    activeColor: Colors.green,
                    selectedColor: Colors.white,
                    activeFillColor: Colors.green,
                    inactiveFillColor: Colors.grey.shade300,
                    selectedFillColor: Colors.grey.shade400,
                    fieldOuterPadding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  enableActiveFill: true,
                  // Enables fill color
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you didn't receive a code",
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  MyCustomTextButton(text: 'Resend', onPressed: () {}),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Or',
                  style: TextStyle(fontSize: 16, color: AppColor.blackColor,fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildSocialButton(
                    icon: FontAwesomeIcons.google,
                    onTap: () {
                      // Handle Google login
                    },
                  ),
                  SizedBox(width: 16),
                  buildSocialButton(
                    icon: FontAwesomeIcons.facebook,
                    onTap: () {
                      // Handle Facebook login
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Text(
                'Do you have an account?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColor.blueColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 18, color: AppColor.blueColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
