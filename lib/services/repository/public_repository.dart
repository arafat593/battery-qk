import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:olabisiolai_flutter_app/constant/app_api_url.dart';
import 'package:olabisiolai_flutter_app/services/api/api_services.dart';
import 'package:olabisiolai_flutter_app/utils/app_log.dart';

class PublicRepository {
  PublicRepository._privateConstructor();
  static final PublicRepository _instance =
      PublicRepository._privateConstructor();
  static PublicRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<dynamic> getHomeBusinesses({String? search}) async {
    try {
      final url = search != null && search.isNotEmpty
          ? "${_api.businessesHome}?search=$search"
          : _api.businessesHome;
      var response = await _apiServices.getServices(url);
      return response;
    } catch (e) {
      errorLog("getHomeBusinesses repo", e);
      return null;
    }
  }

  Future<dynamic> getCategories() async {
    try {
      var response = await _apiServices.getServices(_api.categories);
      return response;
    } catch (e) {
      errorLog("getCategories repo", e);
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
        body: {"business_id": businessId},
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
    List<File>? images,
  }) async {
    try {
      Map<String, dynamic> body = {
        "business_id": businessId,
        "full_name": fullName,
        "is_anonymous": isAnonymous,
        "rating": rating,
        "review_text": reviewText,
      };

      dynamic requestBody = body;

      if (images != null && images.isNotEmpty) {
        List<MultipartFile> multipartImages = [];
        for (var image in images) {
          if (await image.exists()) {
            String fileName = image.path.split('/').last;
            var mimeType = lookupMimeType(image.path);
            multipartImages.add(
              await MultipartFile.fromFile(
                image.path,
                filename: fileName,
                contentType: MediaType.parse(mimeType ?? "image/jpeg"),
              ),
            );
          }
        }
        body["images[]"] = multipartImages;
        requestBody = FormData.fromMap(body);
      }

      var response = await _apiServices.postServices(
        url: _api.reviewStore,
        body: requestBody,
      );
      return response;
    } catch (e) {
      errorLog("submitReview repo", e);
      return null;
    }
  }
}
