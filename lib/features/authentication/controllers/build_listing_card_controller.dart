import 'package:batteryqk_web_app/data/services/api_services.dart';
import 'package:batteryqk_web_app/features/authentication/models/build_listing_card_model.dart';
import 'package:get/get.dart';

class BuildListingCardController extends GetxController {
  final ApiService _apiService = ApiService();

  var listingCardData = <BuildListingCardModel>[].obs;
  var filteredListingData = <BuildListingCardModel>[].obs;

  var isloading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 150), fetchListData);
    super.onInit();
  }

  void refreshForLanguage() {
    fetchListData();
  }

  Future<void> fetchListData() async {
    try {
      isloading(true);
      hasError(false);

      final data = await _apiService.showListing();

      listingCardData.value = data;
      filteredListingData.value = data;

    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
    } finally {
      isloading(false);
    }
  }

  /// ✅ User-friendly error message
  String get userFriendlyError {
  final msg = errorMessage.value.toLowerCase();

  if (msg.contains("failed host lookup") || msg.contains("socketexception")) {
    return "no_internet".tr;
  } else if (msg.contains("timeout")) {
    return "timeout_error".tr;
  } else if (msg.contains("404")) {
    return "data_not_found".tr;
  } else {
    return "generic_error".tr;
  }
}


  /// ✅ Reset filters
  void resetFilters() {
    filteredListingData.value = listingCardData;
  }
}
