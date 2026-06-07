import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyCustomIcon extends StatelessWidget {
  const MyCustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.facebook, color: AppColor.blueColor),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(FontAwesomeIcons.twitter, color: AppColor.blueColor),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(FontAwesomeIcons.instagram, color: AppColor.blueColor),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(FontAwesomeIcons.whatsapp, color: AppColor.blueColor),
        ),
      ],
    );
  }
}
