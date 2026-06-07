import 'package:batteryqk_web_app/data/services/booking_history_service.dart';
import 'package:batteryqk_web_app/features/authentication/models/bookinghistory/booking_model.dart';
import 'package:get/get.dart';

class BookingHistoryController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var bookingList = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooking();
  }

  Future<void> fetchBooking() async {
    try {
      isLoading(true); // Show loading spinner
      hasError(false); // Reset error state
      // Fetch the bookings from the service
      final bookings = await BookingHistoryService.getBookings();

      // Check if data is fetched properly
      if (bookings.isNotEmpty) {
        bookingList.value = bookings;
      } else {
        // Handle case when no data is returned
        bookingList.clear();
      }
    } catch (e) {
      hasError(true); // Set error state if an error occurs
      errorMessage(e.toString()); // Save error message for debugging
      print("Error fetching data: $e"); // Log error for debugging
    } finally {
      isLoading(false); // Hide loading spinner
    }
  }
}
