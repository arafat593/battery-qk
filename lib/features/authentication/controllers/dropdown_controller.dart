import 'package:get/get.dart';

class DropdownController extends GetxController {
  var selectedMainCategories = <String>[].obs;
  var selectedSubCategories = <String>[].obs;
  var selectedSports = <String>[].obs;

  var selectedLocation = RxnString();
  var selectedAgeGroup = RxnString();
  var selectedRating = RxnString();
  var selectedGender = RxnString();
  var selectedPrice = RxnString();
  var selectedDiscount = RxnString();


}
