import 'dart:convert';
import 'package:batteryqk_web_app/common/widgets/show_snack_bar.dart';
import 'package:batteryqk_web_app/data/services/utility/urls.dart';
import 'package:batteryqk_web_app/features/authentication/models/build_listing_card_model.dart';
import 'package:batteryqk_web_app/features/authentication/models/user_login.dart';
import 'package:batteryqk_web_app/features/authentication/views/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:batteryqk_web_app/features/authentication/controllers/auth_controller.dart';

import '../../features/authentication/controllers/language_controller.dart';
import '../../features/authentication/models/user_data.dart';

class ApiService {
  static Future<void> createUser(UserCreate user, BuildContext context) async {
    final String url = Urls.userCreate;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showSnackbar(context, "Success", "User created successfully");
      } else {
        showSnackbar(
          context,
          "Failed",
          "User creation failed: ${response.statusCode}",
        );
      }
    } catch (e) {
      showSnackbar(context, "Error", "An error occurred: $e");
    }
  }

  static Future<void> userLogIn(
    UserLogin userLogin,
    BuildContext context,
  ) async {
    final String url = Urls.userLogin;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userLogin.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String token = responseBody['token'];

        await AuthController.saveToken(token);
      }
    } catch (e) {
      showSnackbar(context, "Error", "An error occurred: $e");
    }
  }

  Future<List<BuildListingCardModel>> showListing() async {
    final String url = Urls.showAllListing;
    final String? token = await AuthController.getToken();

    // Get the current language from the controller:
    final LanguageController languageController =
        Get.find<LanguageController>();
    final String acceptLanguage = languageController.currentLanguage;
    print('Accept-Language: $acceptLanguage');

    if (token == null || token.isEmpty) {
      throw Exception('Token is not available');
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          if (acceptLanguage.isNotEmpty) 'Accept-Language': acceptLanguage,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> listingData = jsonData['data']['listings'];
        return listingData
            .map((e) => BuildListingCardModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load listings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> makeBooking({
    required int listingId,
    required String bookingDate,
    required String bookingHours,
    required int numberOfPersons,
    required String additionalNote,
    required BuildContext context,
  }) async {
    final String url = Urls.booking;
    // Get the current language from the controller:
    final LanguageController languageController =
        Get.find<LanguageController>();
    final String acceptLanguage = languageController.currentLanguage;

    final String? token = await AuthController.getToken();
    final Map<String, dynamic> bookingData = {
      "listingId": listingId,
      "bookingDate": bookingDate,
      "booking_hours": bookingHours,
      "numberOfPersons": numberOfPersons,
      "additionalNote": additionalNote,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          // Only include if not empty
          if (acceptLanguage.isNotEmpty) 'Accept-Language': acceptLanguage,
        },
        body: jsonEncode(bookingData),//responsebody
      );

      // Check if the response is successful
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Handle success
        if (responseData['success'] == true) {
          // Show success message
          final message = responseData['data']['message'];
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: Text('booking_successful'.tr),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => HistoryScreen());
                      },
                      child: Text('ok'.tr),
                    ),
                  ],
                ),
          );
        } else {
          // Handle failure
          final message = responseData['message'] ?? "Failed to create booking";
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: Text('Booking Failed'),
                  content: Text(message),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
          );
        }
      } else {
        // Handle non-200 status code
        showDialog(
          context: context,
          builder:
              (BuildContext context) => AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      // Handle error
      showDialog(
        context: context,
        builder:
            (BuildContext context) => AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred: $e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> sendReview(int bookingId, int rating, String comment) async {
    final String url = Urls.sentReview;

    // Get token
    final String? token = await AuthController.getToken();
    final LanguageController languageController =
        Get.find<LanguageController>();
    final String acceptLanguage = languageController.currentLanguage;

    // Request body
    final Map<String, dynamic> reviewData = {
      "bookingId": bookingId,
      "rating": rating,
      "comment": comment,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          if (acceptLanguage.isNotEmpty) 'Accept-Language': acceptLanguage,
        },
        body: json.encode(reviewData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the request is successful
        final responseBody = json.decode(response.body);
        if (responseBody['success']) {
          final message = responseBody['data']['message'];
          final reviewId = responseBody['data']['reviewId'];
          final status = responseBody['data']['status'];
          final listingName = responseBody['data']['listingName'];

          print('Review Submitted Successfully!');
          print('Message: $message');
          print('Review ID: $reviewId');
          print('Status: $status');
          print('Listing Name: $listingName');
        } else {
          print('Error: ${responseBody['data']['message']}');
        }
      } else {
        // Handle failure response (e.g., 4xx, 5xx errors)
        print('Failed to submit review: ${response.statusCode}');
        print("Response body: ${response.body}");
      }
    } catch (e) {
      // Handle network or other errors
      Exception('Error submitting review: $e');
    }
  }
}
