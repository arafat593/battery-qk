import 'package:flutter/material.dart';

class CustomElevatedIconButton extends StatelessWidget {
  final String buttonText;
  final Widget? icon;
  final Function()? onPressed;
  final Color color;

  const CustomElevatedIconButton({
    super.key,
    required this.buttonText,
    this.icon,
    this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        buttonText,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
