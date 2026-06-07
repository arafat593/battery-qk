import 'package:flutter/material.dart';


class MyCustomTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const MyCustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
