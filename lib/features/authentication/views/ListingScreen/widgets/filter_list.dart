import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_dropdown_Listings.dart';
import '../../../../../common/widgets/multi_dropdown.dart';
import '../../../../../util/colors.dart';
import '../../../controllers/dropdown_controller.dart';

class FilterModal extends StatelessWidget {
  final DropdownController dropdownController;
  final List<String> allLocation;
  final List<String> ageGroup;
  final List<String> discount;
  final List<String> rating;
  final List<String> gender;
  final List<String> price;
  final bool isLogin;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const FilterModal({
    super.key,
    required this.dropdownController,
    required this.allLocation,
    required this.ageGroup,
    required this.discount,
    required this.rating,
    required this.gender,
    required this.price,
    required this.isLogin,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'apply_filters'.tr,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            MultiDropDown(),
            CustomDropdownListings(
              itemList: allLocation,
              listType: 'all_location'.tr,
              onChanged: (value) =>
                  dropdownController.selectedLocation.value = value,
            ),
            CustomDropdownListings(
              itemList: ageGroup,
              listType: 'age_group'.tr,
              onChanged: (value) =>
                  dropdownController.selectedAgeGroup.value = value,
            ),
            CustomDropdownListings(
              itemList: discount,
              listType: 'discount'.tr,
              onChanged: (value) =>
                  dropdownController.selectedDiscount.value = value,
            ),
            CustomDropdownListings(
              itemList: rating,
              listType: 'rating'.tr,
              onChanged: (value) =>
                  dropdownController.selectedRating.value = value,
            ),
            CustomDropdownListings(
              itemList: gender,
              listType: 'gender'.tr,
              onChanged: (value) =>
                  dropdownController.selectedGender.value = value,
            ),
            CustomDropdownListings(
              itemList: price,
              listType: 'price'.tr,
              onChanged: (value) =>
                  dropdownController.selectedPrice.value = value,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApply,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text('apply_filters'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLogin
                          ? AppColor.blueColor
                          : Colors.grey.shade200,
                      foregroundColor: isLogin ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    label: Text('reset'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLogin
                          ? Colors.grey.shade200
                          : AppColor.blueColor,
                      foregroundColor: isLogin ? Colors.black87 : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
