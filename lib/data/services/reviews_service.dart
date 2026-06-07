import 'dart:convert';
import 'package:batteryqk_web_app/data/services/utility/urls.dart';
import 'package:http/http.dart' as http;
import '../../../features/authentication/controllers/auth_controller.dart';
import 'eview_submit_model.dart';


class ReviewService {
  static Future<bool> submitReview(ReviewSubmitModel review) async {
    final token = await AuthController.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('User token is not available');
    }

    final url = Uri.parse(Urls.reviews);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(review.toJson()),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Review submission failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error submitting review: $e");
      return false;
    }
  }
}
