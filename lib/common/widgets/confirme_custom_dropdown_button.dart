
import 'package:flutter/material.dart';

class ConfirmCustomDropdownButton extends StatelessWidget {
  final List<String> itemList;
  final String listType;

  const ConfirmCustomDropdownButton({
    super.key,
    required this.itemList,
    required this.listType,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        items: itemList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          // your logic here
        },
        decoration: InputDecoration(
          labelText: listType,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
        ),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );

  }
}