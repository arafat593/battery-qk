import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';

final accountSettingsProvider = StateNotifierProvider.autoDispose<AccountSettingsNotifier, AccountSettingsState>((ref) {
  return AccountSettingsNotifier();
});

class AccountSettingsState {
  final bool isLoading;
  final bool isSaving;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool wantsMarketingEmails;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final String photo;
  final String location;
  
  AccountSettingsState({
    this.isLoading = false,
    this.isSaving = false,
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.phone = "",
    this.wantsMarketingEmails = false,
    this.emailNotifications = true,
    this.pushNotifications = false,
    this.smsNotifications = true,
    this.photo = "",
    this.location = "",
  });

  AccountSettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? wantsMarketingEmails,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    String? photo,
    String? location,
  }) {
    return AccountSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      wantsMarketingEmails: wantsMarketingEmails ?? this.wantsMarketingEmails,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      photo: photo ?? this.photo,
      location: location ?? this.location,
    );
  }
}

class AccountSettingsNotifier extends StateNotifier<AccountSettingsState> {
  final UserRepository _userRepository = UserRepository.instance;
  
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  AccountSettingsNotifier() : super(AccountSettingsState()) {
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    state = state.copyWith(isLoading: true);
    try {
      var response = await _userRepository.getSettings();
      if (response != null && response['data'] != null) {
        var profile = response['data']['profile'];
        var settings = response['data']['settings'];
        var notifications = {};
        if (settings is Map) {
          notifications = settings['notifications'] ?? {};
        }

        // Use local storage (which stores data from Login/SignUp API) as a fallback
        var localData = await StorageServices.instance.getLogDedData();
        String localPhoto = localData["photo"] ?? localData["avatar"] ?? "";
        String localLocation = localData["location"] ?? "";

        String apiFullName = profile?['name'] ?? localData['name'] ?? "";
        String apiFirstName = profile?['first_name'] ?? localData['first_name'] ?? "";
        String apiLastName = profile?['last_name'] ?? localData['last_name'] ?? "";
        String apiEmail = profile?['email'] ?? localData['email'] ?? "";
        String apiPhone = profile?['phone'] ?? localData['phone'] ?? "";

        // Safely extract first/last name if API only returns 'name'
        if (apiFirstName.isEmpty && apiFullName.isNotEmpty) {
           var parts = apiFullName.trim().split(" ");
           apiFirstName = parts.first;
           apiLastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";
        }
        
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false, 
          firstName: apiFirstName,
          lastName: apiLastName, 
          email: apiEmail,
          phone: apiPhone,
          photo: profile?['photo'] ?? profile?['avatar'] ?? profile?['image'] ?? localPhoto,
          location: profile?['location'] ?? profile?['address'] ?? localLocation,
          wantsMarketingEmails: profile?['wants_marketing_emails'] == 1 || profile?['wants_marketing_emails'] == true,
          emailNotifications: notifications['email'] == 1 || notifications['email'] == true,
          pushNotifications: notifications['push'] == 1 || notifications['push'] == true,
          smsNotifications: notifications['sms'] == 1 || notifications['sms'] == true,
        );

        fullNameController.text = "${state.firstName} ${state.lastName}".trim();
        emailController.text = state.email;
        phoneController.text = state.phone;
        locationController.text = state.location;
      } else {
        if (!mounted) return;
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      errorLog("fetchSettings", e);
      if (!mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  void updateWantsMarketingEmails(bool value) => state = state.copyWith(wantsMarketingEmails: value);
  void updateEmailNotifications(bool value) => state = state.copyWith(emailNotifications: value);
  void updatePushNotifications(bool value) => state = state.copyWith(pushNotifications: value);
  void updateSmsNotifications(bool value) => state = state.copyWith(smsNotifications: value);

  Future<void> saveSettings() async {
    state = state.copyWith(isSaving: true);
    try {
      var names = fullNameController.text.trim().split(" ");
      var firstName = names.isNotEmpty ? names.first : "";
      var lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

      var response = await _userRepository.updateSettings(
        firstName: firstName,
        lastName: lastName,
        phone: phoneController.text,
        wantsMarketingEmails: state.wantsMarketingEmails,
        settings: {
          "notifications": {
            "email": state.emailNotifications,
            "push": state.pushNotifications,
            "sms": state.smsNotifications,
          }
        }
      );
      
      // Update local storage so it reflects immediately
      var localData = await StorageServices.instance.getLogDedData();
      localData["first_name"] = firstName;
      localData["last_name"] = lastName;
      localData["name"] = "$firstName $lastName".trim();
      localData["phone"] = phoneController.text;
      localData["location"] = locationController.text;
      Map<String, String> stringData = localData.map((key, value) => MapEntry(key.toString(), value.toString()));
      await StorageServices.instance.setLogDedData(stringData);
      
      if (!mounted) return;
      state = state.copyWith(isSaving: false, location: locationController.text);
      if (response != null) {
         AppSnackBar.instance.success("Settings updated successfully.");
         fetchSettings();
      }
    } catch (e) {
      errorLog("saveSettings", e);
      if (!mounted) return;
      state = state.copyWith(isSaving: false);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
