import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/screens/categories_screen/widget/categories_content.dart';
import 'package:olabisiolai_flutter_app/screens/categories_screen/widget/category_side_bar.dart';
import 'package:olabisiolai_flutter_app/screens/map_screen/widget/custom_map_app_bar.dart';

import '../../constant/app_asserts_icons_path.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.home_repair_service_outlined, 'name': 'Home\nServices'},
    {'icon': Icons.laptop_mac, 'name': 'Tech &\nGadgets'},
    {'icon': Icons.gavel, 'name': 'Legal &\nAdvisory'},
    {'icon': Icons.directions_car_filled_outlined, 'name': 'Automotive'},
    {'icon': Icons.medical_services_outlined, 'name': 'Health &\nWellness'},
    {'icon': Icons.local_shipping_outlined, 'name': 'Logistics'},
    {'icon': Icons.restaurant_menu, 'name': 'Food &\nDining'},
    {'icon': Icons.checkroom, 'name': 'Fashion &\nStyle'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomMapAppBar(
            logoPath: AppAssertsIconsPath.instance.gidiraNameLogo,
            onSearchTap: () {
              debugPrint("Search clicked");
            },
          ),

          Expanded(
            child: Row(
              children: [
                CategorySidebar(
                  categories: categories,
                  selectedIndex: selectedIndex,
                  onTap: (index) {
                    setState(() => selectedIndex = index);
                  },
                ),

                Expanded(
                  child: CategoryContent(
                    title: categories[selectedIndex]['name'].toString(),
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
