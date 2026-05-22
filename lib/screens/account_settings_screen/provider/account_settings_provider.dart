import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:olabisiolai_flutter_app/services/repository/user_repository.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';
import 'package:olabisiolai_flutter_app/utils/app_snack_bar.dart';
import 'package:olabisiolai_flutter_app/services/storage/storage_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';

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
  final String pickedImagePath;
  
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
    this.pickedImagePath = "",
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
    String? pickedImagePath,
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
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
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

        // Use local storage ONLY as a fallback if profile is completely null or missing keys
        var localData = await StorageServices.instance.getLogDedData();
        String localPhoto = localData["photo"] ?? localData["avatar"] ?? "";
        String localLocation = localData["location"] ?? "";

        // Prioritize profile from API
        String apiFirstName = profile?['first_name'] ?? "";
        String apiLastName = profile?['last_name'] ?? "";
        String apiFullName = profile?['name'] ?? "";
        String apiEmail = profile?['email'] ?? "";
        String apiPhone = profile?['phone'] ?? "";
        String apiPhoto = profile?['image_url'] ?? profile?['image_path'] ?? profile?['photo'] ?? profile?['avatar'] ?? "";
        String apiLocation = profile?['location'] ?? profile?['address'] ?? "";

        // If API data is missing, then fallback to localData
        if (apiFirstName.isEmpty && apiLastName.isEmpty && apiFullName.isNotEmpty) {
           var parts = apiFullName.trim().split(" ");
           apiFirstName = parts.first;
           apiLastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";
        }
        
        // Final resolution with fallback
        String firstName = apiFirstName.isNotEmpty ? apiFirstName : (localData['first_name'] ?? "");
        String lastName = apiLastName.isNotEmpty ? apiLastName : (localData['last_name'] ?? "");
        String email = apiEmail.isNotEmpty ? apiEmail : (localData['email'] ?? "");
        String phone = apiPhone.isNotEmpty ? apiPhone : (localData['phone'] ?? "");
        String photo = apiPhoto.isNotEmpty ? apiPhoto : localPhoto;
        String location = apiLocation.isNotEmpty ? apiLocation : localLocation;

        // Ensure photo URL is absolute if it's from API
        if (photo.isNotEmpty && !photo.startsWith('http')) {
           photo = "${AppApiUrl.domain}/storage/$photo";
        }

        if (!mounted) return;
        state = state.copyWith(
          isLoading: false, 
          firstName: firstName,
          lastName: lastName, 
          email: email,
          phone: phone,
          photo: photo,
          location: location,
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

  Future<bool> saveSettings() async {
    state = state.copyWith(isSaving: true);
    try {
      var names = fullNameController.text.trim().split(" ");
      var firstName = names.isNotEmpty ? names.first : "";
      var lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

      var response = await _userRepository.updateSettings(
        firstName: firstName,
        lastName: lastName,
        phone: phoneController.text,
        location: locationController.text,
        wantsMarketingEmails: state.wantsMarketingEmails,
        imagePath: state.pickedImagePath, // Pass the image path here
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
      
      if (!mounted) return false;
      state = state.copyWith(isSaving: false, location: locationController.text, pickedImagePath: "");
      if (response != null) {
         AppSnackBar.instance.success("Settings updated successfully.");
         fetchSettings();
         return true;
      }
      return false;
    } catch (e) {
      errorLog("saveSettings", e);
      if (!mounted) return false;
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        state = state.copyWith(pickedImagePath: image.path);
      }
    } catch (e) {
      errorLog("pickImage", e);
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
