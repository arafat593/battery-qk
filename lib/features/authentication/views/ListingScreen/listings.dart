import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../util/colors.dart';
import '../../controllers/build_listing_card_controller.dart';
import '../../controllers/dropdown_controller.dart';
import 'widgets/filter_list.dart';
import 'widgets/listing_list.dart';

class Listings extends StatefulWidget {
  const Listings({super.key, required this.isBack});
  final bool isBack;

  @override
  State<Listings> createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  bool islogin = true;
  String? selectedLocation;
  String? selectedAgeGroup;
  String? selectedRating;
  String? selectedGender;
  String? selectedPrice;
  void _resetFilters() {
    setState(() {
      islogin = false;
    });

    // Clear ALL filters in the dropdown controller
    dropdownController.selectedMainCategories.clear();
    dropdownController.selectedSubCategories.clear();
    dropdownController.selectedSports.clear();

    dropdownController.selectedLocation.value = null;
    dropdownController.selectedAgeGroup.value = null;
    dropdownController.selectedRating.value = null;
    dropdownController.selectedGender.value = null;
    dropdownController.selectedPrice.value = null;

    // Reset the data back to original
    _listController.filteredListingData.value = _listController.listingCardData;

    Navigator.pop(context);
  }

  final _listController = Get.find<BuildListingCardController>();
  final dropdownController = Get.put(DropdownController());
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async => await _listController.fetchListData();
  Future<void> applyFilter() async {
    final allData = _listController.listingCardData;

    final filtered =
        allData.where((item) {
          final matchesAge =
              dropdownController.selectedAgeGroup.value == null ||
              dropdownController.selectedAgeGroup.value!.isEmpty ||
              item.ageGroup.any(
                (age) =>
                    age.toLowerCase().trim() ==
                    dropdownController.selectedAgeGroup.value!
                        .toLowerCase()
                        .trim(),
              );

          final matchesGender =
              dropdownController.selectedGender.value == null ||
              dropdownController.selectedGender.value!.isEmpty ||
              item.gender.toLowerCase().trim() ==
                  dropdownController.selectedGender.value!.toLowerCase().trim();

          final matchesLocation =
              dropdownController.selectedLocation.value == null ||
              dropdownController.selectedLocation.value!.isEmpty ||
              item.location.toLowerCase().trim() ==
                  dropdownController.selectedLocation.value!
                      .toLowerCase()
                      .trim();

          final matchesPrice =
              dropdownController.selectedPrice.value == null ||
              dropdownController.selectedPrice.value!.isEmpty ||
              item.price == dropdownController.selectedPrice.value;

          final matchesRating =
              dropdownController.selectedRating.value == null ||
              dropdownController.selectedRating.value!.isEmpty ||
              item.averageRating.toString() ==
                  dropdownController.selectedRating.value;

          final matchesMainCategory =
              dropdownController.selectedMainCategories.isEmpty ||
              dropdownController.selectedMainCategories.any(
                (selected) => item.mainFeatures.toLowerCase().trim().contains(
                  selected.toLowerCase().trim(),
                ),
              );

          final matchesSubCategory =
              dropdownController.selectedSubCategories.isEmpty ||
              dropdownController.selectedSubCategories.any(
                (selected) => item.mainSubCategories
                    .toLowerCase()
                    .trim()
                    .contains(selected.toLowerCase().trim()),
              );

          final matchesSports =
              dropdownController.selectedSports.isEmpty ||
              dropdownController.selectedSports.any(
                (selected) => item.allSprots.toLowerCase().trim().contains(
                  selected.toLowerCase().trim(),
                ),
              );
          final matchesDiscount =
              dropdownController.selectedDiscount.value == null ||
              dropdownController.selectedDiscount.value!.isEmpty ||
              item.discount.toLowerCase().trim() ==
                  dropdownController.selectedDiscount.value!
                      .toLowerCase()
                      .trim();

          return matchesAge &&
              matchesGender &&
              matchesLocation &&
              matchesPrice &&
              matchesRating &&
              matchesMainCategory &&
              matchesSubCategory &&
              matchesDiscount &&
              matchesSports;
        }).toList();

    _listController.filteredListingData.value = filtered;

    Navigator.pop(context);
  }

  void _showFilterModal() {
    List<String> discount =
        _listController.listingCardData.map((e) => e.discount).toSet().toList();
    List<String> allLocation =
        _listController.listingCardData.map((e) => e.location).toSet().toList();
    List<String> ageGroup =
        _listController.listingCardData
            .map((e) => e.ageGroup[0])
            .toSet()
            .toList();
    List<String> rating =
        _listController.listingCardData
            .map((e) => e.averageRating.toString())
            .toSet()
            .toList();
    List<String> gender =
        _listController.listingCardData.map((e) => e.gender).toSet().toList();
    List<String> price =
        _listController.listingCardData.map((e) => e.price).toSet().toList();

    showModalBottomSheet(
      backgroundColor: AppColor.whiteColor,
      elevation: 4,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FilterModal(
          dropdownController: dropdownController,
          allLocation: allLocation,
          ageGroup: ageGroup,
          discount: discount,
          rating: rating,
          gender: gender,
          price: price,
          isLogin: islogin,
          onApply: applyFilter,
          onReset: _resetFilters,
        );
      },
    ).whenComplete(() {
      // ✅ This runs when user taps outside or closes the sheet
      dropdownController.selectedMainCategories.clear();
      dropdownController.selectedSubCategories.clear();
      dropdownController.selectedSports.clear();
      dropdownController.selectedLocation.value = null;
      dropdownController.selectedAgeGroup.value = null;
      dropdownController.selectedRating.value = null;
      dropdownController.selectedGender.value = null;
      dropdownController.selectedPrice.value = null;
      dropdownController.selectedDiscount.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(isBack: widget.isBack),
      ),
      body: Obx(() {
        if (_listController.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_listController.hasError.value) {
          debugPrint(_listController.errorMessage.value); // optional for devs
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _listController.userFriendlyError,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _listController.fetchListData,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ListingsList(listController: _listController)],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterModal,
        backgroundColor: AppColor.blueColor,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(
          Icons.filter_alt_outlined,
          size: 28,
          color: AppColor.whiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
