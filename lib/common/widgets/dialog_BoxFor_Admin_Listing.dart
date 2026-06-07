import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batteryqk_web_app/util/images_path.dart';
import 'package:batteryqk_web_app/util/text_string.dart';

class DialogBoxForAdminListing extends StatelessWidget {
  final int starCount = 5;
  const DialogBoxForAdminListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  AppText.academies1Title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  AppImages.academies1a,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              _buildLabelValue('Name', AppText.academies1Title),
              _buildLabelValue('Category', 'Swimming'),
              _buildLabelValue('Location', 'DownTown'),
              _buildLabelValue('Age Group', 'All age'),
              _buildLabelValue('Price', 'Paid'),
              _buildRatingRow(),
              _buildLabelValue('Featured', 'No', icon: Icons.close_outlined, iconColor: Colors.red),
              Text('Description', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 4),
              Text(AppText.academies1Details, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  child: const Text('Close'),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value, {IconData? icon, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icon != null)
                Icon(icon, color: iconColor ?? Colors.black54, size: 16),
              if (icon != null) const SizedBox(width: 4),
              Text(value, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rating', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              starCount,
                  (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
