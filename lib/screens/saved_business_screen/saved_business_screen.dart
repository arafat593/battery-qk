import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../utils/gap.dart';

class SavedBusinessesScreen extends StatelessWidget {
  const SavedBusinessesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedItems = [
      {
        "name": "The Oasis Luxury Spa",
        "category": "WELLNESS",
        "location": "Victoria Island, Lagos",
        "rating": "4.9",
        "isVerified": true,
        "image": "https://images.unsplash.com/photo-1584622650111-993a426fbf0a",
      },
      {
        "name": "Healthy Bites Cafe",
        "category": "NUTRITION",
        "location": "Ikeja, Lagos",
        "rating": "4.8",
        "isVerified": false,
        "image":
            "https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: "Saved Businesses"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "MY CURATION",
              color: AppColors.instance.success,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            const Gap(height: 5),
            AppText(
              text: "Your Saved\nBusinesses",
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
            const Gap(height: 25),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedItems.length,
              separatorBuilder: (context, index) => const Gap(height: 20),
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return _buildBusinessCard(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  item['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.red, size: 14),
                      const Gap(width: 4),
                      AppText(text:
                        item['rating'],
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item['isVerified']
                            ? Colors.pink[50]
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['isVerified'] ? "VERIFIED" : "UNVERIFIED",
                        style: TextStyle(
                          color: item['isVerified'] ? Colors.pink : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(width: 8),
                    Text(
                      item['category'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.bookmark,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ],
                ),
                const Gap(height: 8),
                AppText(text:
                  item['name'],
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                ),
                Text(
                  item['location'],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Gap(height: 16),

                // Buttons
                AppButton(
                  title: "Direct Message",
                  leadingIconImage: AppAssertsIconsPath.instance.messageIcon,
                ),
                const Gap(height: 10),
                AppButton(
                  title: "View Profile",
                  backgroundColor: AppColors.instance.transparent,
                  borderColor: AppColors.instance.hintText,
                  titleColor: AppColors.instance.black500,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
