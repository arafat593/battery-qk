import 'package:batteryqk_web_app/common/widgets/custom_app_bar.dart';
import 'package:batteryqk_web_app/util/images_path.dart';
import 'package:flutter/material.dart';

class CarService extends StatelessWidget {
  const CarService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 253, 245),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(isBack: true),
      ),
      body: Center(child: Image.asset(AppImages.blurPenguineImage)),
    );
  }
}
