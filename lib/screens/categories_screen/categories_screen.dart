import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/screens/categories_screen/widget/categories_content.dart';
import 'package:olabisiolai_flutter_app/screens/categories_screen/widget/category_side_bar.dart';
import 'package:olabisiolai_flutter_app/screens/map_screen/widget/custom_map_app_bar.dart';

import 'package:olabisiolai_flutter_app/widgets/inputs/custom_floationg_search_widget.dart';
import '../../constant/app_asserts_icons_path.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/provider/home_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  int selectedIndex = 0;
  bool isSearchVisible = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

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
    if (categoryName.contains("health") || categoryName.contains("medical")) return Icons.medical_services;
    if (categoryName.contains("auto") || categoryName.contains("car")) return Icons.directions_car_filled;
    if (categoryName.contains("legal") || categoryName.contains("adv")) return Icons.gavel;
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    
    var apiCategories = homeState.categories;
    var uiCategories = <Map<String, dynamic>>[];
    
    if (apiCategories.isEmpty) {
      uiCategories = [
        {'icon': Icons.home_repair_service_outlined, 'name': 'Home\nServices'},
        {'icon': Icons.laptop_mac, 'name': 'Tech &\nGadgets'},
        {'icon': Icons.gavel, 'name': 'Legal &\nAdvisory'},
        {'icon': Icons.directions_car_filled_outlined, 'name': 'Automotive'},
        {'icon': Icons.medical_services_outlined, 'name': 'Health &\nWellness'},
        {'icon': Icons.local_shipping_outlined, 'name': 'Logistics'},
        {'icon': Icons.restaurant_menu, 'name': 'Food &\nDining'},
        {'icon': Icons.checkroom, 'name': 'Fashion &\nStyle'},
      ];
    } else {
      for (var c in apiCategories) {
         uiCategories.add({
            'icon': _getCategoryIcon(c['name'] ?? ""),
            'name': (c['name'] ?? "").toString().replaceAll(" & ", " &\n"),
            'id': c['id']
         });
      }
    }

    int safeSelectedIndex = selectedIndex < uiCategories.length ? selectedIndex : 0;
    
    final selectedCategory = uiCategories.isNotEmpty ? uiCategories[safeSelectedIndex] : null;
    final categoryId = selectedCategory != null ? selectedCategory['id'] : null;
    
    List<dynamic> filteredBusinesses = [];
    if (categoryId != null) {
       filteredBusinesses = homeState.businesses.where((b) {
          final matchesCategory = b['category'] != null && b['category']['id'] == categoryId;
          if (!matchesCategory) return false;
          
          if (searchQuery.isEmpty) return true;
          final name = (b['business_name'] ?? "").toString().toLowerCase();
          return name.contains(searchQuery);
       }).toList();
    } else if (apiCategories.isEmpty) {
       filteredBusinesses = homeState.businesses.where((b) {
          if (searchQuery.isEmpty) return true;
          final name = (b['business_name'] ?? "").toString().toLowerCase();
          return name.contains(searchQuery);
       }).toList();
    }

    return Scaffold(
      body: Column(
        children: [
          CustomMapAppBar(
            logoPath: AppAssertsIconsPath.instance.gidiraNameLogo,
            onSearchTap: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
                if (!isSearchVisible) {
                  searchController.clear();
                  searchQuery = "";
                }
              });
            },
          ),

          if (isSearchVisible)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: CustomFloatingSearchWidget(
                controller: searchController,
                hintText: "Search in ${selectedCategory != null ? selectedCategory['name'].toString().replaceAll("\n", " ") : "categories"}...",
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchQuery = "");
                  },
                ),
              ),
            ),

          Expanded(
            child: homeState.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Row(
              children: [
                CategorySidebar(
                  categories: uiCategories,
                  selectedIndex: safeSelectedIndex,
                  onTap: (index) {
                    setState(() => selectedIndex = index);
                  },
                ),

                Expanded(
                  child: CategoryContent(
                    title: selectedCategory != null ? selectedCategory['name'].toString().replaceAll("\n", "") : "Services",
                    businesses: filteredBusinesses,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
