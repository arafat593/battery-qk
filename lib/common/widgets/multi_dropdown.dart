import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/authentication/controllers/build_listing_card_controller.dart';
import '../../features/authentication/controllers/dropdown_controller.dart';
import 'custom_multiSelect_dropdown.dart';

class MultiDropDown extends StatelessWidget {
  MultiDropDown({super.key});

  final controller = Get.find<BuildListingCardController>();
  final dropdownController = Get.put(DropdownController());

  @override
  Widget build(BuildContext context) {
    List<String> availableMainCategories =
        controller.listingCardData.map((e) => e.mainFeatures).toSet().toList();
    List<String> availableSubMainCategories =
        controller.listingCardData
            .map((e) => e.mainSubCategories)
            .toSet()
            .toList();
    List<String> allSports =
        controller.listingCardData.map((e) => e.allSprots).toSet().toList();
    return Column(
      children: [
        Obx(
          () => CustomMultiSelectDropdown(
            title: "all_main_categories".tr,
            options: availableMainCategories,
            selectedValues: dropdownController.selectedMainCategories.toList(),
            onSelectionChanged: (selected) {
              dropdownController.selectedMainCategories.value = selected;
              dropdownController.selectedSubCategories.clear();
              dropdownController.selectedSports.clear();
            },
          ),
        ),
        Obx(
          () => CustomMultiSelectDropdown(
            title: "all_sub_categories".tr,
            options: availableSubMainCategories,
            selectedValues: dropdownController.selectedSubCategories.toList(),
            onSelectionChanged: (selected) {
              dropdownController.selectedSubCategories.value = selected;
              dropdownController.selectedSports.clear();
            },
          ),
        ),
        Obx(
          () => CustomMultiSelectDropdown(
            title: "all_sports".tr,
            options: allSports,
            selectedValues: dropdownController.selectedSports.toList(),
            onSelectionChanged: (selected) {
              dropdownController.selectedSports.value = selected;
            },
          ),
        ),
      ],
    );
  }
}
