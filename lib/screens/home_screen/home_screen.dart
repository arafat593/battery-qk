import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/app_navigation_screen/app_navigation_screen.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_app_bar.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_category_grid.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/professional_card.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_section_header.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_service_tile.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/custom_floationg_search_widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/provider/home_provider.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String categoryName) {
    categoryName = categoryName.toLowerCase();
    if (categoryName.contains("food") || categoryName.contains("cater")) return Icons.restaurant;
    if (categoryName.contains("repair") || categoryName.contains("home")) return Icons.home_repair_service;
    if (categoryName.contains("tech") || categoryName.contains("laptop")) return Icons.laptop_mac;
    if (categoryName.contains("event")) return Icons.event;
    if (categoryName.contains("beauty") || categoryName.contains("fashion")) return Icons.content_cut;
    if (categoryName.contains("plumb")) return Icons.plumbing;
    if (categoryName.contains("electric")) return Icons.electric_bolt;
    if (categoryName.contains("clean")) return Icons.cleaning_services;
    if (categoryName.contains("logistic") || categoryName.contains("transport")) return Icons.local_shipping;
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    var categories = homeState.categories;
    if (categories.isEmpty) {
      categories = [
        {'name': 'PLUMBING', 'icon': Icons.plumbing},
        {'name': 'ELECTRIC', 'icon': Icons.electric_bolt},
        {'name': 'CLEANING', 'icon': Icons.cleaning_services},
        {'name': 'BEAUTY', 'icon': Icons.content_cut},
        {'name': 'LOGISTICS', 'icon': Icons.local_shipping},
        {'name': 'PEST', 'icon': Icons.bug_report},
        {'name': 'PAINTING', 'icon': Icons.format_paint},
        {'name': 'FOOD', 'icon': Icons.restaurant},
      ];
    } else {
      categories = categories.take(8).toList();
    }

    final allBusinesses = List<dynamic>.from(homeState.businesses);
    allBusinesses.sort((a, b) => ((b['average_rating'] ?? 0) as num).compareTo((a['average_rating'] ?? 0) as num));

    // Apply search filter
    List<dynamic> filteredBusinesses = allBusinesses;
    if (_searchQuery.isNotEmpty) {
      filteredBusinesses = allBusinesses.where((b) {
        final name = (b['business_name'] ?? '').toString().toLowerCase();
        final location = (b['location']?['name'] ?? '').toString().toLowerCase();
        final category = (b['category']?['name'] ?? '').toString().toLowerCase();
        return name.contains(_searchQuery) || location.contains(_searchQuery) || category.contains(_searchQuery);
      }).toList();
    }

    final professionals = filteredBusinesses.where((b) => (b['average_rating'] ?? 0) >= 4.5).toList();
    final recentServices = filteredBusinesses.take(8).toList();
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
                  controller: _searchController,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: HomeSectionHeader(
                title: "Curated Categories",
                actionText: "View All",
                onActionTap: () {
                  try {
                    appNavigationKey.currentState?.changeNavigation(1);
                  } catch (e) {
                    errorLog("HomeScreen", e);
                  }
                },
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
                  String label = "";
                  IconData icon = Icons.category;
                  
                  if (item is Map && item.containsKey('label')) {
                     label = item['label'];
                     icon = item['icon'];
                  } else if (item is Map && item.containsKey('name')) {
                     label = item['name'].toString().split(" ").first; // Keep it short for grid
                     icon = item['icon'] ?? _getCategoryIcon(item['name']);
                  }

                  return CategoryCard(
                    icon: icon,
                    label: label.toUpperCase(),
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
                  child: homeState.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : professionals.isEmpty 
                      ? Center(child: AppText(text: "No professionals found", fontWeight: FontWeight.w700, fontSize: 12,))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: professionals.length,
                          itemBuilder: (context, index) {
                            var pro = professionals[index];
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
                              imageUrl: pro['logo_url'] ?? 'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
                            );
                          },
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
                child: homeState.isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : recentServices.isEmpty
                    ? const Center(child: Text("No services found"))
                    : Column(
                        children: List.generate(recentServices.length, (index) {
                          var service = recentServices[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSize.height(value: 2),
                              horizontal: AppSize.width(value: 8),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                AppRoutes.instance.pushNamed(
                                  AppRoutesKey.instance.businessProfile,
                                  pathParameters: {"id": service['id'].toString()},
                                );
                              },
                              child: HomeServiceListTile(
                                title: service['business_name'] ?? "Unknown",
                                location: service['location']?['name'] ?? "Unknown",
                                distance: "",
                                rating: (service['average_rating'] ?? 0.0).toDouble(),
                                imageUrl: service['logo_url'],
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
