import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images_path.dart';

class CustomDetailsImageGroup extends StatelessWidget {
  final String image1a;
  final String image1b;
  final String image1c;
  final String image1d;
  final String image1e;

  const CustomDetailsImageGroup({
    super.key,
    required this.image1a,
    required this.image1b,
    required this.image1c,
    required this.image1d,
    required this.image1e,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top large image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                image1a.isNotEmpty
                    ? Image.network(image1a, fit: BoxFit.cover)
                    : Image.asset(AppImages.logo, fit: BoxFit.cover),
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha((0.5 * 255).toInt()), // 127
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'academy_overview'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // First row of two smaller images
        Row(
          children: [
            _buildSmallImage(image1b, size),
            const SizedBox(width: 16),
            _buildSmallImage(image1c, size),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildSmallImage(image1d, size),
            const SizedBox(width: 16),
            _buildSmallImage(image1e, size),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallImage(String imagePath, Size size) {
    final isNetworkImage = imagePath.isNotEmpty;

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: size.height * 0.18,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.08 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              isNetworkImage
                  ? Image.network(imagePath, fit: BoxFit.cover)
                  : Image.asset(AppImages.logo, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
