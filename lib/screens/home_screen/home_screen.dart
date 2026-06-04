import 'dart:async';
import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_app_bar.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_category_grid.dart';
import 'package:olabisiolai_flutter_app/screens/common_widget/professional_card.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/provider/home_provider.dart';
import 'package:olabisiolai_flutter_app/screens/account_settings_screen/provider/account_settings_provider.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/custom_floationg_search_widget.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:olabisiolai_flutter_app/screens/app_navigation_screen/app_navigation_screen.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_section_header.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/widget/home_service_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;
  bool _showAllCategories = false;
  String? _currentLocationText;

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String city = place.locality ?? place.subAdministrativeArea ?? "";
        final String country = place.country ?? "";
        if (!mounted) return;
        setState(() {
          if (city.isNotEmpty && country.isNotEmpty) {
            _currentLocationText = "$city, $country";
          } else if (city.isNotEmpty) {
            _currentLocationText = city;
          }
        });
      }
    } catch (e) {
      debugPrint("Error getting position: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).fetchHomeData();
      ref.read(accountSettingsProvider.notifier).fetchSettings();
      _determinePosition();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  IconData _getCategoryIcon(String categoryName) {
    categoryName = categoryName.toLowerCase();
    if (categoryName.contains("food") || categoryName.contains("cater"))
      return Icons.restaurant;
    if (categoryName.contains("repair") || categoryName.contains("home"))
      return Icons.home_repair_service;
    if (categoryName.contains("tech") || categoryName.contains("laptop"))
      return Icons.laptop_mac;
    if (categoryName.contains("event")) return Icons.event;
    if (categoryName.contains("beauty") || categoryName.contains("fashion"))
      return Icons.content_cut;
    if (categoryName.contains("plumb")) return Icons.plumbing;
    if (categoryName.contains("electric")) return Icons.electric_bolt;
    if (categoryName.contains("clean")) return Icons.cleaning_services;
    if (categoryName.contains("logistic") || categoryName.contains("transport"))
      return Icons.local_shipping;
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final settingsState = ref.watch(accountSettingsProvider);
    final String locationText =
        _currentLocationText ??
        (settingsState.location.isNotEmpty
            ? settingsState.location
            : "Lagos, Nigeria");
    var categories = homeState.categories;
    if (!_showAllCategories) {
      categories = categories.take(8).toList();
    }

    final allBusinesses = List<dynamic>.from(homeState.businesses);
    allBusinesses.sort(
      (a, b) => ((b['average_rating'] ?? 0) as num).compareTo(
        (a['average_rating'] ?? 0) as num,
      ),
    );

    final List<dynamic> filteredBusinesses = allBusinesses;

    final professionals = filteredBusinesses
        .where((b) => (b['average_rating'] ?? 0) >= 4.5)
        .toList();
    final recentServices = filteredBusinesses.take(8).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(
        logoPath: AppAssertsIconsPath.instance.gidiraNameLogo,
        locationText: locationText,
        onLocationTap: null,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(homeProvider.notifier).fetchHomeData(search: _searchQuery),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.02),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        _searchQuery = value;
                      });
                      _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        ref
                            .read(homeProvider.notifier)
                            .fetchHomeData(search: value);
                      });
                    },
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = "");
                              _debounce?.cancel();
                              ref.read(homeProvider.notifier).fetchHomeData();
                            },
                          )
                        : null,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: HomeSectionHeader(
                    title: "Search Results for '$_searchQuery'",
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.height(value: 20),
                    ),
                    child: homeState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredBusinesses.isEmpty
                        ? const Center(
                            child: Text("No services found matching search"),
                          )
                        : Column(
                            children: List.generate(filteredBusinesses.length, (
                              index,
                            ) {
                              var service = filteredBusinesses[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSize.height(value: 4),
                                  horizontal: AppSize.width(value: 8),
                                ),
                                child: ProfessionalCard(
                                  onTap: () async {
                                    await AppRoutes.instance.pushNamed(
                                      AppRoutesKey.instance.businessProfile,
                                      pathParameters: {
                                        "id": service['id'].toString(),
                                      },
                                    );
                                    ref
                                        .read(homeProvider.notifier)
                                        .fetchHomeData();
                                  },
                                  name: service['business_name'] ?? "Unknown",
                                  rating: (service['average_rating'] ?? 0.0)
                                      .toDouble(),
                                  reviews: service['reviews_count'] ?? 0,
                                  imageUrl:
                                      service['logo_url'] ??
                                      'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
                                  phone: service['phone'] ?? service['mobile'],
                                  vendorUuid: service['vendor']?['uuid']?.toString() ?? service['vendor_uuid']?.toString(),
                                  businessName: service['business_name'] ?? service['name'],
                                  logoUrl: service['logo_url'],
                                ),
                              );
                            }),
                          ),
                  ),
                ),
              ] else ...[
                if (categories.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: HomeSectionHeader(
                      title: "Curated Categories",
                      actionText: _showAllCategories ? "Show Less" : "View All",
                      onActionTap: () {
                        setState(() {
                          _showAllCategories = !_showAllCategories;
                        });
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          label = item['name']
                              .toString()
                              .split(" ")
                              .first; // Keep it short for grid
                          icon = item['icon'] ?? _getCategoryIcon(item['name']);
                        }

                        return GestureDetector(
                          onTap: () {
                            if (item is Map && item['id'] != null) {
                              ref
                                      .read(selectedCategoryIdProvider.notifier)
                                      .state =
                                  item['id'];
                              ref.read(navigationIndexProvider.notifier).state =
                                  1;
                            }
                          },
                          child: CategoryCard(
                            icon: icon,
                            label: label.toUpperCase(),
                          ),
                        );
                      },
                    ),
                  ),
                ],

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
                          ? Center(
                              child: AppText(
                                text: "No professionals found",
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: professionals.length,
                              itemBuilder: (context, index) {
                                var pro = professionals[index];
                                return ProfessionalCard(
                                  onTap: () async {
                                    await AppRoutes.instance.pushNamed(
                                      AppRoutesKey.instance.businessProfile,
                                      pathParameters: {
                                        "id": pro['id'].toString(),
                                      },
                                    );
                                    ref
                                        .read(homeProvider.notifier)
                                        .fetchHomeData();
                                  },
                                  name: pro['business_name'] ?? "Unknown",
                                  rating: (pro['average_rating'] ?? 0.0)
                                      .toDouble(),
                                  reviews: pro['reviews_count'] ?? 0,
                                  imageUrl:
                                      pro['logo_url'] ??
                                      'https://static.photo-ac.com/static/assets/image/logo/photo_open_graph.jpeg',
                                  width: AppSize.size.width * 0.7,
                                  phone: pro['phone'] ?? pro['mobile'],
                                  vendorUuid: pro['vendor']?['uuid']?.toString() ?? pro['vendor_uuid']?.toString(),
                                  businessName: pro['business_name'] ?? pro['name'],
                                  logoUrl: pro['logo_url'],
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
                            children: List.generate(recentServices.length, (
                              index,
                            ) {
                              var service = recentServices[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSize.height(value: 2),
                                  horizontal: AppSize.width(value: 8),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    await AppRoutes.instance.pushNamed(
                                      AppRoutesKey.instance.businessProfile,
                                      pathParameters: {
                                        "id": service['id'].toString(),
                                      },
                                    );
                                    ref
                                        .read(homeProvider.notifier)
                                        .fetchHomeData();
                                  },
                                  child: HomeServiceListTile(
                                    title:
                                        service['business_name'] ?? "Unknown",
                                    location:
                                        service['location']?['name'] ??
                                        "Unknown",
                                    distance: "",
                                    rating: (service['average_rating'] ?? 0.0)
                                        .toDouble(),
                                    imageUrl: service['logo_url'],
                                  ),
                                ),
                              );
                            }),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
