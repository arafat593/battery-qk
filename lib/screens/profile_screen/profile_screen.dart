import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../widgets/texts/app_text.dart';
import '../../utils/gap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
      appBar: CustomAppBar(
        title: "Profile",
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {
              AppRoutes.instance.pushNamed(
                AppRoutesKey.instance.editProfileScreen,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=amara',
                  ),
                ),
              ),
            ),
            const Gap(height: 15),
            AppText(
              text: "Amara Okafor",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                AppText(
                  text: " Lagos, Nigeria",
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ],
            ),
            const Gap(height: 25),

            // --- Stats Cards ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard("03", "SAVED"),
                  const Gap(width: 15),
                  _buildStatCard("12", "REVIEWS"),
                ],
              ),
            ),
            const Gap(height: 25),

            // --- Menu Items ---
            MenuSection(
              items: [
                MenuItemTile(
                  icon: Icons.bookmark_outline,
                  title: "Saved Businesses",
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.savedBusinessesScreen,
                    );
                  },
                ),
                MenuItemTile(
                  icon: Icons.chat_bubble_outline,
                  title: "My Reviews",
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.myReviewsScreen,
                    );
                  },
                ),
              ],
            ),

            const Gap(height: 20),

            MenuSection(
              items: [
                MenuItemTile(
                  icon: Icons.info_outline,
                  title: "About Us",
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.aboutUsScreen,
                    );
                  },
                ),
                MenuItemTile(
                  icon: Icons.verified_user_outlined,
                  title: "Privacy Policy",
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.privacyPolicyScreen,
                    );
                  },
                ),
                MenuItemTile(
                  icon: Icons.description_outlined,
                  title: "Terms of Service",
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.termsAndConditionsScreen,
                    );
                  },
                ),
                MenuItemTile(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {
                    AppRoutes.instance.pushNamed(
                      AppRoutesKey.instance.accountSettingsScreen,
                    );
                  },
                ),
              ],
            ),

            const Gap(height: 30),
            // --- Logout Button ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                title: "Logout",
                backgroundColor: AppColors.instance.transparent,
                leading: Icons.logout,
                titleColor: AppColors.instance.black500,
                iconColor: AppColors.instance.black500,
                borderColor: AppColors.instance.black500,
              ),
            ),
            const Gap(height: 20),
            AppText(
              text: "GIDIRA V2.4.1 • CURATOR EDITION",
              fontSize: 10,
              color: Colors.grey,
            ),
            const Gap(height: 30),
          ],
        ),
      ),
    );
  }

  // Stats Card Widget
  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            AppText(text: value, fontSize: 22, fontWeight: FontWeight.bold),
            AppText(
              text: label,
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuItemTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blueGrey, size: 22),
      ),
      title: AppText(text: title, fontSize: 15, fontWeight: FontWeight.w500),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

class MenuSection extends StatelessWidget {
  final List<Widget> items;

  const MenuSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: items),
    );
  }
}
