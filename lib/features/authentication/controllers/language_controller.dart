import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class LanguageController extends GetxController {
  var isEnglish = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadLanguagePreference();
  }

  // Load the saved language preference from SharedPreferences
  void _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isEnglish.value = prefs.getBool('isEnglish') ?? true;  // Default to true (English)
    updateLanguage(isEnglish.value);
  }

  // Toggle language and save preference in SharedPreferences
  void toggleLanguage(bool value) async {
    isEnglish.value = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEnglish', value);  // Save the preference

    updateLanguage(value);  // Update the locale
  }

  // Update the locale based on the value of isEnglish
  void updateLanguage(bool isEnglish) {
    Get.updateLocale(Locale(isEnglish ? 'en' : 'ar', isEnglish ? 'US' : ''));
  }

  // Returns '' for English, 'ar' for Arabic
  String get currentLanguage => isEnglish.value ? '' : 'ar';
}
