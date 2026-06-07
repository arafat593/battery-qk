import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/colors.dart';

class OfferContainer extends StatelessWidget {
  const OfferContainer({super.key, required this.offer});
  final String offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${'get'.tr} $offer% ${'off'.tr}',
        style: TextStyle(fontSize: 12, color: AppColor.whiteColor),
      ),
    );
  }
}
