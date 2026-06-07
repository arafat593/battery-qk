import 'package:batteryqk_web_app/common/widgets/show_snack_bar.dart';
import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  var userList = <UserModel>[].obs;
  var userLocation = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      final result = await UserService.getAllUser();
      if (result.isNotEmpty) {
        userList.value = result;
        print('userList $userList');
      } else {
        print('No user found');
      }
    } catch (e) {
      print('Error loading user: $e');
      if (Get.context != null) {
        showSnackbar(
          Get.context!,
          "Error",
          e.toString().split('] ').last,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
