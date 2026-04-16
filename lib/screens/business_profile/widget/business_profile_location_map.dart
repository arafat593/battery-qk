import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class BusinessProfileLocationMap extends StatelessWidget {
  const BusinessProfileLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Service Area",
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        AppText(
          text: "New York, NY & Surrounding Boroughs",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.instance.buttonColor,
        ),
        Gap(height: 16),
        Stack(
          children: [
            // Map Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://www.thestatesman.com/wp-content/uploads/2020/04/googl_ED.jpg',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Center Marker (perfect center alignment)
            const Positioned.fill(
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 25,
                  child: Icon(Icons.location_on, color: Colors.white, size: 30),
                ),
              ),
            ),

            // Bottom Button Overlay
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: AppText(
                    text: "Click to expand detailed map",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
