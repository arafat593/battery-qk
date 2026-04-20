import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/screens/categories_screen/categories_screen.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/home_screen.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/message_screen.dart';
import 'package:olabisiolai_flutter_app/screens/profile_screen/profile_screen.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import '../../constant/app_asserts_icons_path.dart';
import '../../error_handling_screen/error_screen.dart';
import '../../services/storage/storage_services.dart';
import '../../utils/app_log.dart';
final GlobalKey<_AppNavigationScreenState> appNavigationKey = GlobalKey<_AppNavigationScreenState>();

class AppNavigationScreen extends StatefulWidget {
  const AppNavigationScreen({super.key});

  @override
  State<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends State<AppNavigationScreen> {
  bool isLoading = true;
  StorageServices storageServices = StorageServices.instance;
  int selectedIndex = 0;
  List<Widget> bodyWidget = [ErrorScreen()];
  List<BottomNavigationBarItem> bottomNavigation = [];

  void changeNavigation(int index) {
    try {
      if (!context.mounted) return;
      setState(() {
        selectedIndex = index;
      });
    } catch (e) {
      errorLog("changeNavigation", e);
    }
  }

  Future<void> onAppInitial() async {
    try {
      await Future.delayed(Durations.medium1);
      bodyWidget = [
        HomeScreen(),
        CategoriesScreen(),
        MessageScreen(),
        ProfileScreen(),
      ];
      bottomNavigation = [
        _buildNavItem(AppAssertsIconsPath.instance.homeIcon, "HOME"),
        _buildNavItem(
          AppAssertsIconsPath.instance.categoriesIcon,
          "CATEGORIES",
        ),
        _buildNavItem(AppAssertsIconsPath.instance.bottomBarMessagesIcon, "MESSAGES"),
        _buildNavItem(AppAssertsIconsPath.instance.profileIcon, "PROFILE"),
      ];
    } catch (e) {
      errorLog("onAppInitial", e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: ImageIcon(AssetImage(iconPath), size: 16),
      ),
      activeIcon: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ImageIcon(
              AssetImage(iconPath),
              color: const Color(0xFF0D47A1),
              size: 16,
            ),
          ],
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : IndexedStack(index: selectedIndex, children: bodyWidget),
      bottomNavigationBar: isLoading || bottomNavigation.length < 2
          ? const Gap()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: BottomNavigationBar(
                items: bottomNavigation,
                onTap: changeNavigation,
                currentIndex: selectedIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: const Color(0xFF0D47A1),
                unselectedItemColor: Colors.blueGrey,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }
}
