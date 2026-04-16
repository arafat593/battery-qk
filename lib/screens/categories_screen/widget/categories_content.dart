import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import '../../../widgets/texts/app_text.dart';
import '../../common_widget/professional_card.dart';

class CategoryContent extends StatelessWidget {
  final String? title;

  const CategoryContent({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.instance.categoriesBackground,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.05),
        children: [
          const Gap(height: 20),
          //Header Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Premium Curation",
                color: AppColors.instance.error,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              Gap(height: 4),
              AppText(
                text: title ?? "Home Services",
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              Gap(height: 6),
              AppText(
                text:
                    "Trusted Nigerian professionals for your home maintenance and lifestyle needs.",
                fontSize: 14,
                color: AppColors.instance.hintText,
              ),
            ],
          ),
          // PROFESSIONAL LIST (FIXED)
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return ProfessionalCard(
                  onTap: (){
                    AppRoutes.instance.pushNamed(AppRoutesKey.instance.businessProfile);
                  },
                  name: "Elite Sparkle Cleaners",
                  rating: 4.9,
                  reviews: 128,
                  imageUrl:
                      'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
