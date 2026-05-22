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
  final List<dynamic>? businesses;

  const CategoryContent({super.key, this.title, this.businesses});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.instance.categoriesBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(-5, 0), // Shadow towards the sidebar
          ),
        ],
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size.width * 0.05,
        ),
        children: [
          const Gap(height: 20),

          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Premium Curation",
                color: AppColors.instance.error,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              const Gap(height: 4),
              AppText(
                text: title ?? "Home Services",
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              const Gap(height: 6),
              AppText(
                text:
                "Trusted Nigerian professionals for your home maintenance and lifestyle needs.",
                fontSize: 14,
                color: AppColors.instance.deepHintText,
              ),
            ], 
          ),

          // LIST (FIXED)
          businesses == null || businesses!.isEmpty
              ? const Center(
                  child: Padding( 
                    padding: EdgeInsets.all(20),
                    child: Text("No professionals found for this category"),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: businesses!.length,
                  itemBuilder: (context, index) {
                    var pro = businesses![index];
                    return ProfessionalCard(
                      onTap: () {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.businessProfile,
                          pathParameters: {"id": pro['id'].toString()},
                        );
                      },
                      name: pro['business_name'] ?? "Unknown",
                      rating: (pro['average_rating'] ?? 0.0).toDouble(),
                      reviews: pro['reviews_count'] ?? 0,
                      imageUrl: pro['logo_url'] ??
                          'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
                    );
                  },
                ),
        ],
      ),
    );
  }
}
