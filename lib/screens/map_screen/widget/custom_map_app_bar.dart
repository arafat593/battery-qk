import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';

class CustomMapAppBar extends StatelessWidget {
  const CustomMapAppBar({
    super.key,
    this.logoPath,
    this.onSearchTap,
    this.onMenuTap,
    this.showSearch = true,
    this.showMenu = false,
    this.backgroundColor,
    this.padding,
  });

  final String? logoPath;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;
  final bool showSearch;
  final bool showMenu;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.01),
        child: Container(
          color: backgroundColor ?? Colors.transparent,
          padding:
              padding ??
              EdgeInsets.symmetric(horizontal: AppSize.height(value: 16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT: Logo or Menu
              Row(
                children: [
                  if (showMenu)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: onMenuTap,
                    ),

                  if (logoPath != null) AppImage(path: logoPath!, width: 65),
                ],
              ),

              /// RIGHT: Search
              if (showSearch)
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: onSearchTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
