import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_image_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../routes/app_routes.dart';
import '../../routes/app_routes_key.dart';
import '../../services/storage/storage_services.dart';
import '../../utils/app_log.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  StorageServices storageServices = StorageServices.instance;

  Future<void> onAppInitial() async {
    try {
      /*var firstTime = await storageServices.getAppFirstTime();
      if (firstTime) {
        AppRoutes.instance.go(AppRoutesKey.instance.onBoardScreen);
        return;
      }*/

      var token = await storageServices.getToken();
      if (token.isEmpty) {
        AppRoutes.instance.go(AppRoutesKey.instance.loginScreen);
      } else {
        // AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
      }
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      onAppInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssertsImagePath.instance.splashBackground),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Gap(),
              Column(
                children: [
                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraLogo,
                    width: 128,
                  ),
                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraNameLogo,
                    width: 155,
                  ),
                  Gap(height: 20),
                  AppImage(
                    path: AppAssertsIconsPath.instance.splashTitle,
                    width: 230,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: AppSize.height(value: 30)),
                child: AppText(
                  text:
                      "© 2026 Gidira Ecosystem. Nigeria's Premium Business Archive.",
                  color: AppColors.instance.hintText,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
