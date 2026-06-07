import 'package:batteryqk_web_app/common/widgets/custom_dropdown.dart';
import 'package:batteryqk_web_app/features/admin/confirm_dialog_widget.dart';
import 'package:batteryqk_web_app/features/admin/header_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/admin_multi_dropdown.dart';
import '../../common/widgets/calender_screen.dart';
import '../../util/colors.dart';
import 'edit_dialog_box.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({super.key});

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> {
  final List<String> academies = [
    'Elite Swimming Academy',
    'Champions Football Academy',
    'Little Stars Nursery',
    'Hoops Basketball Center',
    'Ace Tennis Club',
    'Bright Beginnings Nursery',
  ];
  final List<String> status = ['Confirm', 'Pending', 'Cancelled'];
  DateTime? _selectedDate;
  final DateFormat _formatter = DateFormat('MM/dd/yyyy');

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (datePicked != null && datePicked != _selectedDate) {
      setState(() {
        _selectedDate = datePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Management",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 30),
          Card(
            color: Colors.white,
            elevation: 0.5,
            shadowColor: Colors.white.withAlpha(179),
            child: Column(
              children: [
                AdminMultiDropdown(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Statuses',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          CustomDropdownButton(
                            itemList: status,
                            listType: 'Select a Status',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            shadowColor: Colors.white.withOpacity(0.5),
                            color: Colors.white,
                            child: GestureDetector(
                              onTap: () => _pickDate(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white70,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                                child: CalenderScreen(
                                  selectedDate: _selectedDate,
                                  formatter: _formatter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 38,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: MaterialButton(
                              onPressed: () {},
                              color: AppColor.blueColor,
                              child: Text(
                                'Apply Filters',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white60,
            child: Row(
              children: const [
                HeaderCell(flex: 1, label: 'ID', fontWeight: FontWeight.bold),
                HeaderCell(flex: 2, label: 'User', fontWeight: FontWeight.bold),
                HeaderCell(
                  flex: 3,
                  label: 'Academy',
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'Date & Time',
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'Status',
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 1,
                  label: 'Payment',
                  fontWeight: FontWeight.bold,
                ),
                HeaderCell(
                  flex: 2,
                  label: 'Actions',
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: Colors.grey.withOpacity(0.2),
                  color: Colors.white,
                  child: Row(
                    children: [
                      HeaderCell(
                        flex: 1,
                        label: index.toString(),
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Remon',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 3,
                        label: 'Mts soft',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: '13/5/25',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 2,
                        label: 'Confirm',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        flex: 1,
                        label: 'Unpaid',
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.normal,
                      ),
                      HeaderCell(
                        fontWeight: FontWeight.bold,
                        flex: 2,
                        icons: [
                          Icons.edit_calendar_outlined,
                          Icons.delete_outline_outlined,
                        ],
                        iconColors: [Colors.brown.shade800, Colors.redAccent],
                        onIconPressed: (value) {
                          if (value == Icons.edit_calendar_outlined) {
                            showConfirmDialog(
                              context: context,
                              title: 'Edit Booking',
                              onConfirmed: () {
                                print('User deleted.');
                              },
                              confirmText: 'Save Changes',
                              cancelText: 'Cancel',
                            );
                          } else if (value == Icons.delete_outline_outlined) {
                            showEditDialog(
                              context: context,
                              title: 'Delete User',
                              onConfirmed: () {
                                print('User deleted.');
                              },
                              confirmText: 'Delete',
                              cancelText: 'Cancel',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
