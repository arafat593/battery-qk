import 'package:flutter/material.dart';

import '../../common/widgets/custom_elevated_Icon_Button.dart';
import '../../util/colors.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Title + Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Category Name Input
                const Text("Category Name"),
                const SizedBox(height: 6),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    hintText: "e.g. Football, Swimming, Gymnastics",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // New Facility Input with Add Button
                const Text("Or Add New Facility"),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _facilityController,
                        decoration: InputDecoration(
                          hintText: "e.g. Pool, Indoor Field, Gym",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomElevatedIconButton(
                      buttonText: "Add",
                      color: AppColor.blueColor,
                      onPressed: () {},
                    ), // why this color didn't show
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  "Current Categories:",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Text(""),
                const SizedBox(height: 12),
                const Text(
                  "Current Facilities:",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Text(""),
                const SizedBox(height: 25),
                // Footer Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    CustomElevatedIconButton(
                      buttonText: "Add Category",
                      color: AppColor.blueColor,
                      onPressed: () {},
                    ), // why this color didn't show
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
