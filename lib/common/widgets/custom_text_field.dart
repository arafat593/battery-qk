import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? icon;
  final String? title;

  final TextEditingController? controller;

  const CustomTextField({super.key, this.title, this.controller, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      height: 42,
      child: Card(
        color: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.white.withOpacity(0.5),
        child: TextFormField(
          style: TextStyle(height: 1),
          decoration: InputDecoration(),
        ),
      ),
    );
  }
}
