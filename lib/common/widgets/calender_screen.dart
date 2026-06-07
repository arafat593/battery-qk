import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({
    super.key,
    required DateTime? selectedDate,
    required DateFormat formatter,
  }) : _selectedDate = selectedDate,
       _formatter = formatter;

  final DateTime? _selectedDate;
  final DateFormat _formatter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Space between icon and date
        Text(
          _selectedDate == null
              ? 'mm/dd/yyyy'
              : _formatter.format(_selectedDate),
          style: TextStyle(
            fontSize: 16,
            color: _selectedDate == null ? Colors.black54 : Colors.black54,
          ),
        ),
        Spacer(),
        Icon(Icons.calendar_today, color: Colors.grey.shade400),
      ],
    );
  }
}
