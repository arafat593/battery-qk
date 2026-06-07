import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/confirme_custom_dropdown_button.dart';
class ConfirmDialogWidget extends StatelessWidget {
  final String title;
  final VoidCallback onConfirmed;
  final String confirmText;
  final String cancelText;
  final bool isEdit;
  final bool isChange;
  final String? initialValue1;
  final String? initialValue2;
  final void Function(String, String)? onEditConfirmed;

  const ConfirmDialogWidget({
    super.key,
    required this.title,
    required this.onConfirmed,
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.isEdit = false,
    this.initialValue1,
    this.initialValue2,
    this.onEditConfirmed,
    this.isChange = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller1 = TextEditingController(text: initialValue1);
    final controller2 = TextEditingController(text: initialValue2);

    final List<String> status = ['Confirm', 'Pending', 'Cancelled'];
    final List<String> payment = ['Paid', 'Unpaid'];

    return Dialog(
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
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Conditional Form Fields
            if (isChange) ...[
              TextField(
                controller: controller1,
                decoration: InputDecoration(
                  labelText: 'Name',
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
              const SizedBox(height: 8),
              TextField(
                controller: controller2,
                decoration: InputDecoration(
                  labelText: 'Email',
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

            ] else ...[
              const SizedBox(height: 8),
           Text('All Status', style: TextStyle(fontSize: 14 , color: Colors.grey.shade400)),
              ConfirmCustomDropdownButton(itemList: status, listType: 'Select a status'),
              const SizedBox(height: 8),
           Text('Payment Status', style: TextStyle(fontSize: 14 , color: Colors.grey.shade400)),
              ConfirmCustomDropdownButton(itemList: payment, listType: 'Select'),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isChange && onEditConfirmed != null) {
                      onEditConfirmed!(controller1.text, controller2.text);
                    } else {
                      onConfirmed();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isEdit || !isChange) ?  Colors.blue:Colors.red ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(confirmText, style: const TextStyle(color: Colors.white)),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showConfirmDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onConfirmed,
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
  bool isEdit = false,
  bool isChange = false,
  String? initialValue1,
  String? initialValue2,
  void Function(String, String)? onEditConfirmed,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ConfirmDialogWidget(
        title: title,
        onConfirmed: onConfirmed,
        confirmText: confirmText,
        cancelText: cancelText,
        isEdit: isEdit,
        initialValue1: initialValue1,
        initialValue2: initialValue2,
        onEditConfirmed: onEditConfirmed, isChange: isChange,
      );
    },
  );
}
