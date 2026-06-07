import 'package:batteryqk_web_app/features/authentication/views/privacy_policy_screen.dart';
import 'package:batteryqk_web_app/features/authentication/views/terms_and_conditons_screen.dart';
import 'package:get/get.dart'; // Add this import for .tr
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndBookingCard extends StatefulWidget {
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;

  const TermsAndBookingCard({super.key, this.onSubmit, this.onCancel});

  @override
  _TermsAndBookingCardState createState() => _TermsAndBookingCardState();
}

class _TermsAndBookingCardState extends State<TermsAndBookingCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'agree_terms'.tr,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: 'booking_agreement'.tr,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'terms_of_service'.tr,
                          style: const TextStyle(
                            color: AppColor.blueColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Terms of Service tap
                                  Get.to(() => TermsAndConditionsScreen());
                                },
                        ),
                        TextSpan(
                          text: 'and'.tr,
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'privacy_policy'.tr,
                          style: const TextStyle(
                            color: AppColor.blueColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Privacy Policy tap
                                  Get.to(() => PrivacyPolicyScreen());
                                },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColor.blueColor,
                ),
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: isChecked ? widget.onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'submit_booking'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }
}
