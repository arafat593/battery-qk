import 'dart:convert';
import 'package:batteryqk_web_app/data/services/utility/urls.dart';
import 'package:batteryqk_web_app/features/authentication/models/bookinghistory/booking_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../features/authentication/controllers/auth_controller.dart';
import '../../features/authentication/controllers/language_controller.dart';

class BookingHistoryService {
  static Future<List<BookingModel>> getBookings() async {
    final url = Uri.parse(Urls.getBooking);
    final String? token = await AuthController.getToken();
    final LanguageController languageController =
        Get.find<LanguageController>();
    final String acceptLanguage = languageController.currentLanguage;

    if (token == null || token.isEmpty) {
      throw Exception('Token is not available');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
          if (acceptLanguage.isNotEmpty) 'Accept-Language': acceptLanguage,
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> data = jsonBody['data'];
        print(data);
        return data.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        print("error ${response.body} - ${response.statusCode}");
        throw Exception("Failed to fetch booking");
      }
    } catch (e) {
      print('Exception during fetch $e');
      throw Exception('something went wrong : $e');
    }
  }
}
