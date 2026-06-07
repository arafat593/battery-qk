import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../util/colors.dart';
import '../../../../../util/images_path.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: MediaQuery.of(context).size.height * 0.001,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildQuickAccessCardWithImage(
          "sprots_academies".tr,
          AppImages.penguinHead,
          context,
        ),
        _buildQuickAccessCardWithImage(
          "nurseries".tr,
          AppImages.houseShape,
          context,
        ),
        _buildQuickAccessCardWithImage(
          "loyalty_points".tr,
          AppImages.car2,
          context,
        ),
        _buildQuickAccessCardWithImage(
          "comming_soon".tr,
          AppImages.blurCarImage,
          context,
        ),
      ],
    );
  }

  Widget _buildQuickAccessCardWithImage(
    String label,
    String imageUrl,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(76, 0, 187, 212),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(31, 0, 187, 212),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl,
            width: 100,
            height: 80,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 40, color: Colors.red),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColor.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
