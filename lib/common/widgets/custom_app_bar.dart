import 'package:batteryqk_web_app/features/authentication/views/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:batteryqk_web_app/util/images_path.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBack;
  final bool showNotification;
  final Function()? onPressed;

  const CustomAppBar({
    super.key,
    this.isBack = false,
    this.showNotification = true,
    this.onPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Material(
          elevation: 4,
          color: Colors.white,
          shadowColor: Colors.black12,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                if (isBack)
                  SizedBox(
                    width: 25.w,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        if (onPressed != null) {
                          onPressed!();
                        } else {
                          Navigator.pop(context);
                        }
                      },

                      tooltip: 'Back',
                    ),
                  ),
                if (!isBack) const SizedBox(width: 0),

                /// Logo & Branding
                Image.asset(AppImages.logo, height: 60, width: 60),
                // const SizedBox(width: 10),
                Text(
                  'Batteryqk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackColor,
                    letterSpacing: 1.0,
                  ),
                ),

                const Spacer(),

                /// Notification Icon
                if (showNotification)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: 28,
                            color: Colors.black87,
                          ),
                          // Optional: Notification badge
                          // Positioned(
                          //   right: 0,
                          //   top: 0,
                          //   child: Container(
                          //     width: 8,
                          //     height: 8,
                          //     decoration: BoxDecoration(
                          //       color: Colors.redAccent,
                          //       shape: BoxShape.circle,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
