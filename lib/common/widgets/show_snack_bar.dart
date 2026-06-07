import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String title, String message) {
  final snackBar = SnackBar(
    content: Text(
      "$title: $message",
      style: TextStyle(fontSize: 16),
    ),
    backgroundColor: Colors.grey.shade800,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
