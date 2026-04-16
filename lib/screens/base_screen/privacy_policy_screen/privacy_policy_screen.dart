import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_bold_subtitle.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_content_text.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/custom_section_title.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../../utils/gap.dart'; // আপনার প্রোজেক্টের গ্যাপ উইজেট

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Privacy Policy"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSectionTitle(title: "Your Privacy is Our Priority."),
            CustomContentText(
              text:
                  "At Gidira, we believe in editorial authority and institutional trust. We archive and present businesses with a commitment to protecting your personal data.",
            ),

            const Gap(height: 20),
            CustomSectionTitle(title: "Our Data Sovereignty Guarantee"),
            CustomContentText(
              text:
                  "Gidira does not and will never sell your personal data to third-party advertisers or data brokers. Your information is used exclusively to facilitate business connections within our ecosystem.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "1. Information We Collect"),
            CustomBoldSubTitle(subTitle: "Personal Information"),
            CustomContentText(
              text:
                  "Name, email address, phone number, and professional profile details provided when creating a Gidira account or inquiring about a business.",
            ),
            CustomBoldSubTitle(subTitle: "Usage Data"),
            CustomContentText(
              text:
                  "IP addresses, device types, browser types, and behavioral patterns while navigating our curated directory to improve your experience.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "2. How We Use Your Data"),
            CustomContentText(
              text:
                  "We process your data to curate a personalized directory experience and facilitate seamless communication between users and businesses.",
            ),
            CustomBoldSubTitle(subTitle: "WhatsApp Integration Context"),
            CustomContentText(
              text:
                  "When you use our \"Click to Chat\" feature, we facilitate a direct link to the business via WhatsApp. Gidira does not store the content of your private conversations. We only record the metadata of the click to help businesses understand their traffic and lead generation.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "3. Data Security"),
            CustomContentText(
              text:
                  "We employ institutional-grade encryption and security protocols to safeguard your information. Our tonal architecture is mirrored in our security—layered, deep, and impenetrable.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "4. Third-Party Links"),
            CustomContentText(
              text:
                  "Our directory contains curated links to external websites and social media platforms. Please note that Gidira has no control over, and assumes no responsibility for, the privacy policies or practices of any third-party sites or services.",
            ),

            const Gap(height: 25),
            CustomSectionTitle(title: "5. Your Rights"),
            CustomBoldSubTitle(subTitle: "Right to Access"),
            CustomContentText(
              text: "Request a copy of the personal data we hold about you.",
            ),
            CustomBoldSubTitle(subTitle: "Right to Rectify"),
            CustomContentText(
              text: "Ask us to correct inaccurate or incomplete information.",
            ),
            CustomBoldSubTitle(subTitle: "Right to Erasure"),
            CustomContentText(
              text:
                  "Request that we delete your data from our systems entirely.",
            ),

            const Gap(height: 40),
          ],
        ),
      ),
    );
  }
}
