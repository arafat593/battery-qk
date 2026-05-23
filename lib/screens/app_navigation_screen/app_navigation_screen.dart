import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/screens/categories_screen/categories_screen.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/home_screen.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/message_screen.dart';
import 'package:olabisiolai_flutter_app/screens/profile_screen/profile_screen.dart';
import 'package:olabisiolai_flutter_app/screens/home_screen/provider/home_provider.dart';
import 'package:olabisiolai_flutter_app/screens/account_settings_screen/provider/account_settings_provider.dart';
import 'package:olabisiolai_flutter_app/screens/message_screen/provider/message_provider.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import '../../constant/app_asserts_icons_path.dart';
import '../../error_handling_screen/error_screen.dart';
import '../../services/storage/storage_services.dart';
import '../../utils/app_log.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);

final GlobalKey<_AppNavigationScreenState> appNavigationKey = GlobalKey<_AppNavigationScreenState>();

class AppNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const AppNavigationScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  bool isLoading = true;
  StorageServices storageServices = StorageServices.instance;
  int selectedIndex = 0;
  List<Widget> bodyWidget = [];
  List<BottomNavigationBarItem> bottomNavigation = [];

  void changeNavigation(int index) {
    try {
      if (!context.mounted) return;
      setState(() {
        selectedIndex = index;
      });
      // Auto load/fetch updated data when switching tabs!
      if (index == 0) {
        ref.read(homeProvider.notifier).fetchHomeData();
        ref.read(accountSettingsProvider.notifier).fetchSettings();
      } else if (index == 1) {
        ref.read(homeProvider.notifier).fetchHomeData();
      } else if (index == 2) {
        ref.read(messageProvider.notifier).fetchConversations();
      } else if (index == 3) {
        ref.read(accountSettingsProvider.notifier).fetchSettings();
      }
    } catch (e) {
      errorLog("changeNavigation", e);
    }
  }

  void onAppInitial() {
    try {
      bodyWidget = [
        const HomeScreen(),
        const CategoriesScreen(),
        const MessageScreen(),
        const ProfileScreen(),
      ];
      bottomNavigation = [
        _buildNavItem(AppAssertsIconsPath.instance.homeIcon, "HOME"),
        _buildNavItem(
          AppAssertsIconsPath.instance.categoriesIcon,
          "CATEGORIES",
        ),
        _buildNavItem(
            AppAssertsIconsPath.instance.bottomBarMessagesIcon, "MESSAGES"),
        _buildNavItem(AppAssertsIconsPath.instance.profileIcon, "PROFILE"),
      ];
      isLoading = false;
    } catch (e) {
      errorLog("onAppInitial", e);
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
    final provIndex = ref.watch(navigationIndexProvider);
    if (provIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        changeNavigation(provIndex);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: (isLoading || bodyWidget.isEmpty)
          ? const Center(child: CircularProgressIndicator.adaptive())
          : IndexedStack(
              index: (selectedIndex >= 0 && selectedIndex < bodyWidget.length)
                  ? selectedIndex
                  : 0,
              children: bodyWidget),
      bottomNavigationBar: isLoading || bottomNavigation.length < 2
          ? const Gap()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: BottomNavigationBar(
                items: bottomNavigation,
                onTap: (index) {
                  ref.read(navigationIndexProvider.notifier).state = index;
                  changeNavigation(index);
                },
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
  void didUpdateWidget(covariant AppNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        selectedIndex = widget.initialIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    onAppInitial();
  }
}
