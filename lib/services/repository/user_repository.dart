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

  Future<dynamic> updateSettings({
    String? firstName,
    String? lastName,
    String? phone,
    bool? wantsMarketingEmails,
    Map<String, dynamic>? settings,
  }) async {
    try {
      Map<String, dynamic> body = {};
      if (firstName != null) body["first_name"] = firstName;
      if (lastName != null) body["last_name"] = lastName;
      if (phone != null) body["phone"] = phone;
      if (wantsMarketingEmails != null) body["wants_marketing_emails"] = wantsMarketingEmails;
      if (settings != null) body["settings"] = settings;

      var response = await _apiServices.patchServices(
        url: _api.userSettings,
        body: body
      );
      return response;
    } catch (e) {
      errorLog("updateSettings repo", e);
      return null;
    }
  }
}
