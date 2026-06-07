import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/custom_dropdown_listings.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.label,
    required this.itemList,
    required this.defaultValue,
    required this.onChanged,
  });

  final String label;
  final List<String> itemList;
  final String defaultValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr),
        CustomDropdownListings(
          itemList: itemList,
          listType: defaultValue,
          onChanged: onChanged,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
