import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget buildSocialButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.blueColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Row(
          children: [
            FaIcon(icon, color: Colors.white),
            SizedBox(width: 10.w),
            Text(
              'sign_up_with_google'.tr,
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
