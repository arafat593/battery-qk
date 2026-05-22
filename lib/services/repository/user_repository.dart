import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class UserRepository {
  UserRepository._privateConstructor();
  static final UserRepository _instance = UserRepository._privateConstructor();
  static UserRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<dynamic> toggleFavorite(int businessInfoId) async {
    try {
      var response = await _apiServices.postServices(
        url: _api.userFavoritesToggle,
        body: {
          "business_info_id": businessInfoId
        }
      );
      return response;
    } catch (e) {
      errorLog("toggleFavorite repo", e);
      return null;
    }
  }

  Future<dynamic> deleteFavorite(int id) async {
    try {
      var response = await _apiServices.deleteServices(
        url: "${_api.userFavorites}/$id"
      );
      return response;
    } catch (e) {
      errorLog("deleteFavorite repo", e);
      return null;
    }
  }

  Future<dynamic> checkFavoriteExists(int id) async {
    try {
      var response = await _apiServices.getServices(
        "${_api.userFavorites}/$id/exists"
      );
      return response;
    } catch (e) {
      errorLog("checkFavoriteExists repo", e);
      return null;
    }
  }

  Future<dynamic> getFavorites() async {
    try {
      var response = await _apiServices.getServices(_api.userFavorites);
      return response;
    } catch (e) {
      errorLog("getFavorites repo", e);
      return null;
    }
  }

  Future<dynamic> getSettings() async {
    try {
      var response = await _apiServices.getServices(_api.userSettings);
      return response;
    } catch (e) {
      errorLog("getSettings repo", e);
      return null;
    }
  }

  Future<dynamic> getProfile() async {
    try {
      var response = await _apiServices.getServices(_api.userProfile);
      return response;
    } catch (e) {
      errorLog("getProfile repo", e);
      return null;
    }
  }

  Future<dynamic> updateSettings({
    String? firstName,
    String? lastName,
    String? phone,
    String? location,
    bool? wantsMarketingEmails,
    Map<String, dynamic>? settings,
    String? imagePath,
  }) async {
    try {
      Map<String, dynamic> body = {};
      if (firstName != null) body["first_name"] = firstName;
      if (lastName != null) body["last_name"] = lastName;
      if (phone != null) body["phone"] = phone;
      if (location != null) body["location"] = location;
      if (wantsMarketingEmails != null) {
        body["wants_marketing_emails"] = wantsMarketingEmails ? 1 : 0;
      }
      if (settings != null) body["settings"] = settings;

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          String fileName = file.path.split('/').last;
          var mimeType = lookupMimeType(file.path);
          body["photo"] = await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType.parse(mimeType ?? "image/jpeg"),
          );
          // Add spoofed method for multipart patch support
          body["_method"] = "PATCH";
        }
      }

      dynamic response;
      if (imagePath != null && imagePath.isNotEmpty) {
        // Use POST with _method spoofing for multipart files
        response = await _apiServices.postServices(
          url: _api.userSettings,
          body: FormData.fromMap(body),
        );
      } else {
        // Regular JSON PATCH for text-only updates
        response = await _apiServices.patchServices(
          url: _api.userSettings,
          body: body
        );
      }
      return response;
    } catch (e) {
      errorLog("updateSettings repo", e);
      return null;
    }
  }

  Future<dynamic> updateProfilePhoto(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      String fileName = file.path.split('/').last;
      var mimeType = lookupMimeType(file.path);
      
      FormData formData = FormData.fromMap({
        "profile": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType ?? "image/jpeg"),
        ),
        "_method": "PATCH",
      });

      var response = await _apiServices.postServices(
        url: _api.userSettings,
        body: formData,
      );
      
      return response;
    } catch (e) {
      errorLog("updateProfilePhoto repo", e);
      return null;
    }
  }

  Future<dynamic> getUserReviews() async {
    try {
      var response = await _apiServices.getServices(_api.userReviews);
      return response;
    } catch (e) {
      errorLog("getUserReviews repo", e);
      return null;
    }
  }
}
