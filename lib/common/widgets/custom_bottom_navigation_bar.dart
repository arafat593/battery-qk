import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:batteryqk_web_app/features/authentication/views/HomeScreen/home_screen.dart';
import 'package:batteryqk_web_app/features/authentication/views/ListingScreen/listings.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:get/get.dart';

import '../../features/authentication/views/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const Listings(isBack: false),
    // const BookScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.zero, // No border radius
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity, // Make it fill the entire width
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Slight opacity
              borderRadius: BorderRadius.zero, // Remove rounded corners
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_filled, 'home'.tr, 0),
                _buildNavItem(Icons.wallet, 'jobs'.tr, 1),
                // _buildNavItem(Icons.calendar_today_outlined, 'book'.tr, 2),
                _buildNavItem(Icons.settings, 'menu'.tr, 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.blueColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 26,
                color: isSelected ? AppColor.blueColor : AppColor.orangeColor,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColor.blueColor : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
