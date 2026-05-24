import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class MapLocationSheetWidget extends StatelessWidget {
  const MapLocationSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Gap(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "SELECTED DESTINATION",
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.instance.error,
                  ),
                  Gap(height: 4),
                  AppText(
                    text: "Victoria Island Mall",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Color(0x1A1E88E5),
                child: Icon(Icons.share_outlined, color: Colors.blue, size: 20),
              ),
            ],
          ),

          Gap(height: 8),

          AppText(
            text: "12 Adeola Odeku St, Victoria Island, Lagos",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.instance.hintText,
          ),

          Gap(height: 24),

          AppButton(
            title: "Confirm Location",
            trailing: Icons.arrow_forward,
            onTap: () {
              AppRoutes.instance.pushNamed(
                AppRoutesKey.instance.appNavigationScreen,
              );
            },
          ),

          Gap(height: 16),
        ],
      ),
    );
  }
}
