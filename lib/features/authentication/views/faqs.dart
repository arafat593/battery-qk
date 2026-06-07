import 'package:batteryqk_web_app/common/widgets/custom_app_bar.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Faqs extends StatelessWidget {
  const Faqs({super.key});

  final List<Map<String, String>> faqData = const [
    {'question': 'faq_q1', 'answer': 'faq_a1'},
    {'question': 'faq_q2', 'answer': 'faq_a2'},
    {'question': 'faq_q3', 'answer': 'faq_a3'},
    {'question': 'faq_q4', 'answer': 'faq_a4'},
    {'question': 'faq_q5', 'answer': 'faq_a5'},
    {'question': 'faq_q6', 'answer': 'faq_a6'},
    {'question': 'faq_q7', 'answer': 'faq_a7'},
    {'question': 'faq_q8', 'answer': 'faq_a8'},
    {'question': 'faq_q9', 'answer': 'faq_a9'},
    {'question': 'faq_q10', 'answer': 'faq_a10'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const CustomAppBar(isBack: true),
      ),
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            ...faqData.map((faq) {
              return Card(
                color: const Color.fromARGB(255, 240, 240, 240),
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColor.whiteColor),
                ),
                child: ExpansionTile(
                  title: Text(
                    faq['question']!.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        faq['answer']!.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
