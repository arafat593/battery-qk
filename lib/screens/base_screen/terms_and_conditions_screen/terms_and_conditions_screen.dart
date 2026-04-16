import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_content_text.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_section_title.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../../utils/gap.dart';
import '../../common_widget/custom_bulet_point.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: "Terms And Condition"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSectionTitle(title: "1. Acceptance of Terms"),
            CustomContentText(
              text:
                  "By accessing or using Gidira's digital curation platform, you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this site.",
            ),
            CustomContentText(
              text:
                  "We reserve the right to review and amend any of these terms at our sole discretion. Upon doing so, we will update this page. Any changes to these terms will take effect immediately from the date of publication.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "2. User Responsibilities"),
            CustomContentText(
              text:
                  "As a user of our platform, you are responsible for maintaining the confidentiality of your account and password and for restricting access to your computer or mobile device. You agree to accept responsibility for all activities that occur under your account.",
            ),
            const Gap(height: 8),
            CustomBulletPoint(
              text:
                  "You must provide accurate and complete information during the registration process.",
            ),
            CustomBulletPoint(
              text:
                  "You may not use the platform for any illegal or unauthorized purpose.",
            ),
            CustomBulletPoint(
              text:
                  "You are responsible for ensuring that your interactions with listed businesses comply with local regulations.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "3. Verified Listing Policy"),
            CustomContentText(
              text:
                  "Our \"Verified\" badge signifies that a business has undergone our editorial curation process. However, Gidira does not guarantee the ongoing quality of service provided by these entities.",
            ),
            CustomContentText(
              text:
                  "Businesses seeking verification must provide authentic documentation. Any attempt to provide fraudulent information will result in immediate and permanent suspension from the Gidira ecosystem.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "4. Limitation of Liability"),
            CustomContentText(
              text:
                  "Gidira and its editorial staff shall not be held liable for any damages that result from the use of, or the inability to use, the materials on this platform or the performance of the businesses curated herein, even if Gidira has been advised of the possibility of such damages.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "5. Intellectual Property"),
            CustomContentText(
              text:
                  "The visual identity, layout design, curation algorithms, and brand anchors of Gidira are the exclusive property of the platform. Unauthorized reproduction or \"scraping\" of curated business data is strictly prohibited and protected by international copyright laws.",
            ),

            const Gap(height: 40),
          ],
        ),
      ),
    );
  }
}
