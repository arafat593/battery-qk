import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/screens/base_screen/faq_screen/models/f_a_q_screen_data_model.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class BaseRepository {
  /////////////// constructor
  BaseRepository._privateConstructor();
  static final BaseRepository _instance = BaseRepository._privateConstructor();
  static BaseRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  String _parseCmsContent(dynamic data) {
    if (data == null || data is! Map) return "";
    
    // Check if "page" exists and is a Map
    if (data["page"] != null && data["page"] is Map) {
      var page = data["page"];
      var content = page["description"] ?? page["content"];
      if (content != null) {
        return content.toString().replaceAll('white-space:pre-wrap;', '').replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
      }
    }
    
    // Fallback directly to data properties
    var directContent = data["content"] ?? data["description"];
    if (directContent != null) {
      return directContent.toString().replaceAll('white-space:pre-wrap;', '').replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    }
    
    return "";
  }

  //////////////// function
  Future<String> termsAndConditions() async {
    try {
      var response = await _apiServices.getServices(_api.termsAndConditions);
      if (response != null) {
        return _parseCmsContent(response["data"]);
      }
    } catch (e) {
      errorLog("termsAndConditions repo", e);
    }
    return "";
  }

  Future<String> aboutUs() async {
    try {
      var response = await _apiServices.getServices(_api.about);
      if (response != null) {
        return _parseCmsContent(response["data"]);
      }
    } catch (e) {
      errorLog("aboutUs repo", e);
    }
    return "";
  }

  Future<String> privacyPolicy() async {
    try {
      var response = await _apiServices.getServices(_api.privacyPolicy);
      if (response != null) {
        return _parseCmsContent(response["data"]);
      }
    } catch (e) {
      errorLog("privacyPolicy repo", e);
    }
    return "";
  }

  Future<List<FAQScreenDataModel>> getAllFaq() async {
    List<FAQScreenDataModel> listOfFaqData = [];
    try {
      var response = await _apiServices.getServices(_api.faq);
      if (response != null) {
        if (response["data"] is List) {
          for (var element in response["data"]) {
            listOfFaqData.add(FAQScreenDataModel.fromJson(element));
          }
        }
      }
    } catch (e) {
      errorLog("getAllFaq", e);
    }
    return listOfFaqData;
  }
}
