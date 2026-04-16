import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/my_reviews_screen/widget/my_reviews_card_widget.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Reviews"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppText(
                text: "ARCHIVE",
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.instance.blue,
              ),
              Gap(height: 12),
              AppText(
                text: "Your Contributions",
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
              Gap(height: 12),
              AppText(
                text:
                    "Reviewing businesses helps the Gidira community thrive and fosters growth for local creators.",
                fontSize: 14,
                color: AppColors.instance.hintText,
              ),
              Gap(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) => MyReviewsCardWidget(
                  name: "Luxe Clean Solutions",
                  date: "2 days ago",
                  rating: 4,
                  review:
                      "The attention to detail was absolutely phenomenal. I've used several cleaning services in the city, but LuxeClean is on another level. Every corner was spotless, and the team was incredibly professional.",
                  reviewImages: [
                    'https://picsum.photos/400/400?random=1',
                    'https://picsum.photos/400/400?random=2',
                    'https://picsum.photos/200/200?random=3',
                    'https://picsum.photos/200/200?random=4',
                    'https://picsum.photos/200/200?random=5',
                    'https://picsum.photos/200/200?random=6',
                    'https://picsum.photos/200/200?random=7',
                    'https://picsum.photos/200/200?random=8',
                    'https://picsum.photos/200/200?random=9',
                  ],
                  imageUrl: '',
                  editButton: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.businessProfileReviewScreen,
                    );
                  },
                ),
              ),
              Gap(height: 12),
              Gap(height: 12),
              Gap(height: 12),
              Gap(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
