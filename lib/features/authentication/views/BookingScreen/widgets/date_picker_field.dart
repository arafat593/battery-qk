import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'booking_helpers.dart';
import 'package:batteryqk_web_app/util/colors.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.controller,
    required this.selectedDate,
    required this.allowedWeekdays,
    required this.onDatePicked,
  });

  final TextEditingController controller;
  final DateTime? selectedDate;
  final List<int> allowedWeekdays;
  final ValueChanged<DateTime?> onDatePicked;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.blueColor),
        ),
        labelText: 'date_month_year'.tr,
        suffixIcon: IconButton(
          onPressed: () async {
            DateTime initial =
                selectedDate ??
                findNextAllowedDate(allowedWeekdays, DateTime.now());
            DateTime? pickedDate = await showDatePicker(
              context: context,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColor.blueColor,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              initialDate: initial,
              selectableDayPredicate:
                  (date) => allowedWeekdays.contains(date.weekday),
            );
            onDatePicked(pickedDate);
          },
          icon: Icon(Icons.calendar_today_outlined, color: AppColor.blueColor),
        ),
      ),
    );
  }
}
