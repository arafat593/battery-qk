import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/saved_business_screen/provider/saved_business_provider.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';

class SavedBusinessesScreen extends ConsumerStatefulWidget {
  const SavedBusinessesScreen({super.key});

  @override
  ConsumerState<SavedBusinessesScreen> createState() =>
      _SavedBusinessesScreenState();
}

class _SavedBusinessesScreenState extends ConsumerState<SavedBusinessesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(savedBusinessProvider.notifier).fetchSavedBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedState = ref.watch(savedBusinessProvider);
    final savedItems = savedState.savedItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: "Saved Businesses"),
      body: savedState.isLoading && savedItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref
                  .read(savedBusinessProvider.notifier)
                  .fetchSavedBusinesses(),
              child: SingleChildScrollView(
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
                    savedItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.bookmark_border,
                                    size: 60,
                                    color: Colors.grey[300],
                                  ),
                                  const Gap(height: 16),
                                  AppText(
                                    text: "No saved businesses yet",
                                    fontSize: 16,
                                    color: AppColors.instance.hintText,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: savedItems.length,
                            separatorBuilder: (context, index) =>
                                const Gap(height: 20),
                            itemBuilder: (context, index) {
                              final item = savedItems[index];
                              return _buildBusinessCard(context, item);
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, dynamic item) {
    final business = item['business_info'] ?? item;
    final businessId = business['business_info_id'] ?? business['id'];
    final businessName = business['business_name'] ?? "Unknown";
    final category =
        business['category_name'] ?? (business['category']?['name'] ?? "");
    final location = business['location'] is Map
        ? (business['location']['name'] ?? business['location']['city'] ?? "")
        : (business['location'] ?? "");
    final rating = (business['average_rating'] ?? business['rating'] ?? 0.0)
        .toString();
    final isVerified =
        business['verification_status'] == 'approved' ||
        business['is_verified'] == true;
    final imageUrl =
        business['logo_url'] ??
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a';
    final favoriteId = item['id'] ?? item['business_info_id'];
    return InkWell(
      onTap: () {
        debugPrint("Tapped on business card: $businessName (ID: $businessId)");
        if (businessId != null) {
          AppRoutes.instance.pushNamed(
            AppRoutesKey.instance.businessProfile,
            pathParameters: {"id": businessId.toString()},
          );
        } else {
          debugPrint("Error: businessId is null for item: $item");
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      if (favoriteId != null) {
                        ref
                            .read(savedBusinessProvider.notifier)
                            .removeFavorite(favoriteId);
                      }
                    },
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
                          AppText(
                            text: rating,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ],
                      ),
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
                          color: isVerified ? Colors.pink[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isVerified ? "VERIFIED" : "UNVERIFIED",
                          style: TextStyle(
                            color: isVerified ? Colors.pink : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(width: 8),
                      Text(
                        category.toUpperCase(),
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
                  AppText(
                    text: businessName,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  Text(
                    location,
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
                    onTap: () {
                      debugPrint(
                        "Clicked View Profile button for: $businessName (ID: $businessId)",
                      );
                      if (businessId != null) {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.businessProfile,
                          pathParameters: {"id": businessId.toString()},
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
