import 'package:batteryqk_web_app/common/widgets/multi_dropdown.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';

class EditDialogBox1 extends StatefulWidget {
  final String level;
  final String title;
  final VoidCallback onConfirmed;
  final String confirmText;
  final String cancelText;
  final bool isEdit;
  final String? initialValue1;
  final String? initialValue2;
  final String? initialValue3;
  final String? initialValue4;
  final String? initialValue5;
  final String? initialValue6;
  final String? initialValue7;
  final void Function(String, String)? onEditConfirmed;

  const EditDialogBox1({
    super.key,
    required this.title,
    required this.onConfirmed,
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.isEdit = false,
    this.initialValue1,
    this.initialValue2,
    this.onEditConfirmed,
    this.initialValue3,
    this.initialValue4,
    this.initialValue5,
    this.initialValue6,
    this.initialValue7,
    required BuildContext context,
    required this.level,
  });

  @override
  State<EditDialogBox1> createState() => _EditDialogBox1State();
}

class _EditDialogBox1State extends State<EditDialogBox1> {
  @override
  Widget build(BuildContext context) {
    final controller1 = TextEditingController(text: widget.initialValue1);
    final controller2 = TextEditingController(text: widget.initialValue2);
    final controller3 = TextEditingController(text: widget.initialValue3);
    final controller4 = TextEditingController(text: widget.initialValue4);
    final controller5 = TextEditingController(text: widget.initialValue5);
    final controller6 = TextEditingController(text: widget.initialValue6);
    final controller7 = TextEditingController(text: widget.initialValue7);

    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          color: AppColor.whiteColor,
          width: 500,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              if (widget.isEdit) ...[
                CustomTextField(controller: controller1, label: 'Name'),
                MultiDropDown(),
                CustomTextField(controller: controller3, label: 'Location'),
                CustomTextField(controller: controller4, label: 'Age Group'),
                CustomTextField(controller: controller5, label: 'Price'),
                CustomTextField(controller: controller6, label: 'Image url'),
                CustomTextField(controller: controller7, label: 'Description'),
              ] else ...[
                const Text(
                  'Are you sure you want to delete this item?',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'This action cannot be undone.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(widget.cancelText),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.isEdit && widget.onEditConfirmed != null) {
                        widget.onEditConfirmed!(
                          controller1.text,
                          controller2.text,
                        );
                      } else {
                        widget.onConfirmed();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isEdit ? Colors.blue : Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      widget.confirmText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        style: TextStyle(color: Colors.grey.shade800),
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),

    );
  }
}

void showEditDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onConfirmed,
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
  bool isEdit = false,
  String? initialValue1,
  String? initialValue2,
  String? initialValue3,
  String? initialValue4,
  String? initialValue5,
  String? initialValue6,
  String? initialValue7,
  void Function(String, String)? onEditConfirmed,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return EditDialogBox1(
        title: title,
        onConfirmed: onConfirmed,
        confirmText: confirmText,
        cancelText: cancelText,
        isEdit: isEdit,
        initialValue1: initialValue1,
        initialValue2: initialValue2,
        onEditConfirmed: onEditConfirmed,
        initialValue3: initialValue3,
        initialValue4: initialValue4,
        initialValue5: initialValue5,
        initialValue6: initialValue6,
        initialValue7: initialValue7,
        context: context,
        level: '',
      );
    },
  );
}
