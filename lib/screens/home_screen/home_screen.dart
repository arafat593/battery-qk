import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_app_bar.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_category_grid.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/professional_card.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_section_header.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_service_tile.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../constant/app_asserts_icons_path.dart';
import '../../routes/app_routes.dart';
import '../../routes/app_routes_key.dart';
import '../../widgets/inputs/custom_floationg_search_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.plumbing, 'label': 'PLUMBING'},
      {'icon': Icons.electric_bolt, 'label': 'ELECTRIC'},
      {'icon': Icons.cleaning_services, 'label': 'CLEANING'},
      {'icon': Icons.content_cut, 'label': 'BEAUTY'},
      {'icon': Icons.local_shipping, 'label': 'LOGISTICS'},
      {'icon': Icons.bug_report, 'label': 'PEST'},
      {'icon': Icons.format_paint, 'label': 'PAINTING'},
      {'icon': Icons.restaurant, 'label': 'FOOD'},
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(
        logoPath: AppAssertsIconsPath.instance.gidiraNameLogo,
        locationText: "Lagos, Nigeria",
        onLocationTap: () {
          AppRoutes.instance.pushNamed(AppRoutesKey.instance.mapScreen);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.02),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomFloatingSearchWidget(
                  hintText: "Find verified services...",
                  prefixIcon: Icon(Icons.search),
                  onTap: () {
                    print("Search tapped");
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: HomeSectionHeader(
                title: "Curated Categories",
                actionText: "View All",
                onActionTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return CategoryCard(
                    icon: item['icon'] as IconData,
                    label: item['label'] as String,
                  );
                },
              ),
            ),

            SliverToBoxAdapter(
              child: HomeSectionHeader(title: "Verified Professionals"),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.height(value: 20),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) => ProfessionalCard(
                      onTap: () {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.businessProfile,
                        );
                      },
                      name: "Elite Sparkle Cleaners",
                      rating: 4.9,
                      reviews: 128,
                      imageUrl:
                          'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: HomeSectionHeader(title: "Recent Popular Services"),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.height(value: 20),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.height(value: 2),
                      horizontal: AppSize.width(value: 8),
                    ),
                    child: HomeServiceListTile(
                      title: "Radiance Beauty Lounge",
                      location: "Victoria Island",
                      distance: "1.2km away",
                      rating: 4.7,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
