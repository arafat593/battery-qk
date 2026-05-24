import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.logoPath,
    this.locationText,
    this.onLocationTap,
    this.backgroundColor,
    this.elevation,
    this.showLocation = true,
    this.leading,
    this.actions,
  });

  final String? logoPath;
  final String? locationText;
  final VoidCallback? onLocationTap;
  final Color? backgroundColor;
  final double? elevation;
  final bool showLocation;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      leading: leading,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// LEFT: Logo
            if (logoPath != null) AppImage(path: logoPath!, width: 65),

            /// RIGHT: Location or custom actions
            if (showLocation)
              onLocationTap != null
                  ? GestureDetector(
                      onTap: onLocationTap,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                          Gap(width: 4),
                          AppText(
                            text: locationText ?? "",
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                          size: 18,
                        ),
                        Gap(width: 4),
                        AppText(
                          text: locationText ?? "",
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    )
            else if (actions != null)
              Row(children: actions!),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
