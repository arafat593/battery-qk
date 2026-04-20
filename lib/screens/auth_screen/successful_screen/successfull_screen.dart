import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../../widgets/inputs/app_input_widget_tow.dart';

class SuccessfullScreen extends StatelessWidget {
  const SuccessfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: AppSize.size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Column(
                    children: [
                      Gap(height: 200),
                      AppImage(
                        path: AppAssertsIconsPath.instance.gidiraNameLogo,
                        width: 116,
                      ),
                      Gap(height: 40),
                      // Welcome Text
                      AppText(
                        text: 'Successful',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                      Gap(height: 12),
                      AppText(
                        text:
                            'Your new password created successfully. Please login by new password. ',
                        textAlign: TextAlign.center,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      Gap(height: 30),
                      AppButton(
                        title: "Go To Login",
                        onTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.loginScreen,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
