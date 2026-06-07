import 'package:batteryqk_web_app/features/authentication/controllers/icon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../styles/styles.dart';

class CustomReviewIcons extends StatelessWidget {
  const CustomReviewIcons({
    super.key,
    this.showText = false,
    this.numOfStar =
        '0', // numOfStar as a default value (it will be overwritten)
    required this.tappable,
  });

  final bool showText;
  final String numOfStar;
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    final iconController = Get.find<IconController>();

    // You can directly access iconController.selectedIndex.value to get the number of selected stars
    final int selectedStars = iconController.selectedIndex.value;

    return Row(
      children: [
        // Loop through 5 stars and determine whether each star is selected or not
        for (int i = 1; i <= 5; i++) // Start loop from 1 to 5 for 5 stars
          Obx(
            () => InkWell(
              onTap:
                  tappable
                      ? () {
                        iconController.isSelected.value = true;
                        iconController.selectedIndex.value = i;
                      }
                      : () {},
              child: Icon(
                Icons.star,
                color:
                    iconController.selectedIndex.value >= i
                        ? Colors
                            .amber // Fill the star if selected
                        : Colors.grey, // Otherwise, empty gray star
                size: 25,
              ),
            ),
          ),
        SizedBox(width: 10),
        // Optionally show the number of selected stars as text
        if (showText) CustomSectionSubtitleText(subtitle: '($selectedStars/5)'),
      ],
    );
  }
}
