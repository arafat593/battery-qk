import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../../utils/gap.dart';
import '../../common_widget/custom_bold_subtitle.dart';
import '../../common_widget/custom_content_text.dart';
import '../../common_widget/custom_section_title.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "About Us"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSectionTitle(title: "Introduction"),
            const Gap(height: 12),
            CustomBoldSubTitle(subTitle: "Archiving Nigerian Excellence."),
            const Gap(height: 8),
            CustomContentText(
              text:
                  "Gidira is more than a directory. It's a curated editorial archive of the most trusted professionals across Nigeria, built for those who value quality above all.",
            ),

            const Gap(height: 30),

            CustomSectionTitle(title: "Our Story"),
            const Gap(height: 12),
            CustomContentText(
              text:
                  "Gidira was born out of a simple, frustrating reality: the difficulty of finding reliable, professional services in Nigeria. We saw a landscape filled with talent but marred by a lack of verified trust and seamless communication.",
            ),
            const Gap(height: 12),
            CustomContentText(
              text:
                  "We started as a small project to bridge the gap between discerning clients and elite service providers. Today, we have evolved into a digital curator, meticulously selecting and verifying businesses to ensure that when you find a professional on Gidira, you are finding the best.",
            ),

            const Gap(height: 30),

            // --- Our Mission Section ---
            CustomSectionTitle(title: "Our Mission"),
            const Gap(height: 12),
            CustomContentText(
              text:
                  "Gidira is dedicated to connecting Nigerians with trusted, verified service providers across the country. We believe in empowering local businesses while making it easier for customers to find reliable services they can trust. Our platform bridges the gap between service providers and customers, creating opportunities for growth and building a thriving digital economy.",
            ),

            const Gap(height: 40),
          ],
        ),
      ),
    );
  }
}
