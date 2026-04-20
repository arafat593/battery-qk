import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

import '../../../widgets/inputs/app_input_widget_tow.dart';

class RecoverPassword extends StatelessWidget {
  const RecoverPassword({super.key});

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
            colors: [
              Color(0xFFDEE9F7), // Light blue top-left
              Colors.white, // White middle
              Color(0xFFDEE9F7), // Light blue bottom-right
            ],
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
                  Gap(),
                  // Logo
                  Column(
                    children: [
                      Gap(height: 100),
                      AppImage(
                        path: AppAssertsIconsPath.instance.gidiraNameLogo,
                        width: 116,
                      ),
                      Gap(height: 40),
                      // Welcome Text
                      AppText(
                        text: 'Recover Password',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                      Gap(height: 12),
                      AppText(
                        text:
                            'Enter the email address or mobile phone number associated with your account.',
                        textAlign: TextAlign.center,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),

                      Gap(height: 30),
                      AppInputWidgetTwo(
                        title: "Password",
                        hintText: "*************",
                      ),
                      AppInputWidgetTwo(
                        title: "Confirm Password",
                        hintText: "**************",
                      ),
                      Gap(height: 30),
                      AppButton(
                        title: "Continue",
                        trailing: Icons.arrow_forward,
                        onTap: () {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.successfullScreen,
                          );
                        },
                      ),
                    ],
                  ),
                  Gap(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
