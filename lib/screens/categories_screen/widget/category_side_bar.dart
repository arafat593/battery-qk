import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class CategorySidebar extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;
  final Function(int) onTap;

  const CategorySidebar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.instance.backGroundColor,
      width: 100,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return InkWell(
            onTap: () => onTap(index),
            child: Container(
              margin: EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.instance.categoriesBackground
                    : Colors.transparent,
                borderRadius: isSelected ? BorderRadius.circular(12) : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    categories[index]['icon'],
                    color: isSelected ? Colors.blue : Colors.black54,
                    weight: 22,
                  ),
                  Gap(height: 8),
                  AppText(
                    text: categories[index]['name'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
