import 'package:flutter/material.dart';

class CustomFloatingSearchWidget extends StatelessWidget {
  const CustomFloatingSearchWidget({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.enabled = true,
    this.readOnly = false,
    this.height,
    this.width,
    this.margin,
  });

  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final bool readOnly;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width ?? double.infinity,
      margin: margin,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        onSubmitted: onSubmitted,
        enabled: enabled,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hintText ?? "Search...",

          /// Prefix Icon
          prefixIcon: prefixIcon ??
              const Icon(Icons.search, size: 20),

          /// Suffix Icon
          suffixIcon: suffixIcon,

          filled: true,
          fillColor: fillColor ?? Colors.grey.shade100,

          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(vertical: 12),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}