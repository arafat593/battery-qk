import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../util/colors.dart';
import '../../controllers/build_listing_card_controller.dart';
import 'widgets/banner_section.dart';
import 'widgets/quick_access_section.dart';
import 'widgets/top_listing_section.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final BuildListingCardController apiController =
      Get.find<BuildListingCardController>();

  Future<void> _refreshData() async {
    await apiController.fetchListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(isBack: false),
      ),
      body: Obx(() {
        if (apiController.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (apiController.hasError.value) {
          debugPrint(apiController.errorMessage.value); // optional for devs
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  apiController.userFriendlyError,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: apiController.fetchListData,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              const BannerSection(),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "featured_activities".tr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff212121),
                  ),
                ),
              ),
              const QuickAccessSection(),
              const SizedBox(height: 30),
              TopListingsSection(apiController: apiController),
            ],
          ),
        );
      }),
    );
  }
}
