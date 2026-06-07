import 'package:batteryqk_web_app/features/authentication/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/show_snack_bar.dart';
import '../../../data/services/firebase_service.dart';
import '../../../util/colors.dart';
import '../views/car_service.dart';
import '../views/faqs.dart';
import '../views/history.dart';
import '../views/login_screen.dart';
import '../views/notification_page.dart';
import '../views/points.dart';
import 'language_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryColor = AppColor.blueColor;

  final nameController = TextEditingController();
  final _focusNode = FocusNode();

  final _locationController = TextEditingController();
  final _locationFocusNode = FocusNode();
  final UserController _controller = Get.find<UserController>();
  final AuthControllers authController = Get.put(AuthControllers());
  Future<void> _refreshData() async => await _controller.fetchUser();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.fetchUser();

      // Load saved location from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedLocation = prefs.getString('user_location');
      if (savedLocation != null && savedLocation.isNotEmpty) {
        _locationController.text = savedLocation;
      }
    });

    // Listen to location text changes and save to SharedPreferences
    _locationController.addListener(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_location', _locationController.text);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    _locationController.dispose();
    _focusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff00BCD4),
        statusBarIconBrightness: Brightness.light,
      ),
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildMenuAndLocationSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ------------------- Header Section -------------------
  Widget _buildHeader() {
    final users = _controller.userList;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 70, 20, 40),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withAlpha(230)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://itsmesagar.wordpress.com/wp-content/uploads/2016/07/man-13.png?w=300',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () =>
                    _controller.isLoading.value
                        ? const Text("Loading…")
                        : Expanded(
                          child: Center(
                            child: Text(
                              users.isNotEmpty
                                  ? "${users.first.fname} ${users.first.lname}"
                                  : "—",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 18, color: AppColor.orangeColor),
                const SizedBox(width: 8),
                Obx(
                  () =>
                      _controller.isLoading.value
                          ? const Text("Loading…")
                          : Text(
                            users.isNotEmpty
                                ? '${users.first.highestRewardCategory?.toLowerCase() ?? ""} ${users.first.totalRewardPoints}'
                                : "—",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------- Menu Buttons & Location -------------------
  Widget _buildMenuAndLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuButton(
            Icons.card_membership_rounded,
            'reward'.tr,
            () => Get.to(() => Points()),
          ),
          _buildMenuButton(
            Icons.build_circle_outlined,
            'car_services'.tr,
            () => Get.to(() => CarService()),
          ),
          _buildMenuButton(
            Icons.help_outline_rounded,
            'faqs'.tr,
            () => Get.to(() => Faqs()),
          ),
          _buildMenuButton(
            Icons.notifications_active_outlined,
            'notifications'.tr,
            () => Get.to(() => NotificationPage()),
          ),
          _buildMenuButton(
            Icons.language_outlined,
            'language'.tr,
            () => Get.to(() => LanguagePage(initialSelection: false)),
          ),
          _buildMenuButton(
            Icons.history,
            'history'.tr,
            () => Get.to(() => HistoryScreen()),
          ),
          _buildMenuButton(Icons.logout, 'logout'.tr, () => signOut()),
          const SizedBox(height: 24),
          _buildLocationSection(),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: AppColor.blueColor),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            shadowColor: Colors.black12,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'location'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 48),
                    child: TextField(
                      controller: _locationController,
                      focusNode: _locationFocusNode,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'enter_your_location'.tr,
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_location_alt),
                  onPressed:
                      () => FocusScope.of(
                        context,
                      ).requestFocus(_locationFocusNode),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ------------------- Logout -------------------
  Future<void> signOut() async {
    try {
      _locationController.text = '';
      await authController.logOut(context);
      showSnackbar(context, 'Success', 'Logged out successfully');
      Get.offAll(() => const LogInScreen());
    } catch (e) {
      showSnackbar(context, 'Logout Error', e.toString().split('] ').last);
    }
  }
}
