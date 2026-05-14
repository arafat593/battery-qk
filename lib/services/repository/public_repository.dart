import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class PublicRepository {
  PublicRepository._privateConstructor();
  static final PublicRepository _instance = PublicRepository._privateConstructor();
  static PublicRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<dynamic> getHomeBusinesses() async {
    try {
      var response = await _apiServices.getServices(_api.businessesHome);
      return response;
    } catch (e) {
      errorLog("getHomeBusinesses repo", e);
      return null;
    }
  }

  Future<dynamic> getBusinessDetails(int id) async {
    try {
      var response = await _apiServices.getServices("${_api.businesses}/$id");
      return response;
    } catch (e) {
      errorLog("getBusinessDetails repo", e);
      return null;
    }
  }

  Future<dynamic> getReviews(int businessId) async {
    try {
      var response = await _apiServices.postServices(
        url: _api.reviews,
        body: {
          "business_id": businessId
        }
      );
      return response;
    } catch (e) {
      errorLog("getReviews repo", e);
      return null;
    }
  }

  Future<dynamic> submitReview({
    required int businessId,
    required String fullName,
    required int isAnonymous,
    required int rating,
    required String reviewText,
  }) async {
    try {
      var response = await _apiServices.postServices(
        url: _api.reviewStore,
        body: {
          "business_id": businessId,
          "full_name": fullName,
          "is_anonymous": isAnonymous,
          "rating": rating,
          "review_text": reviewText,
        }
      );
      return response;
    } catch (e) {
      errorLog("submitReview repo", e);
      return null;
    }
  }
}
