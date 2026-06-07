import 'package:batteryqk_web_app/common/widgets/custom_app_bar.dart';
import 'package:batteryqk_web_app/common/widgets/show_snack_bar.dart';
import 'package:batteryqk_web_app/data/services/api_services.dart';
import 'package:batteryqk_web_app/features/admin/edit_dialog_box.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/terms_and_booking_card.dart';
import 'widgets/booking_helpers.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/dropdown_field.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({
    super.key,
    required this.listingId,
    required this.openingHours,
  });

  final int listingId;
  final String openingHours;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<String> timeList = [];
  late final List<int> allowedWeekdays;
  String selectedTime = '';
  String selectedPerson = '';
  final List<String> personNumber = List.generate(
    20,
    (i) => (i + 1).toString(),
  );
  DateTime? _selectedDate;
  final _dateController = TextEditingController();
  final _requestController = TextEditingController();
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    timeList = generateTimeSlots(widget.openingHours);
    allowedWeekdays = parseAllowedWeekdays(widget.openingHours);
  }

  DateTime getCombinedDateTime(DateTime date, String timeLabel) {
    final match = RegExp(r'(\d{1,2}):(\d{2}) (\w{2})').firstMatch(timeLabel);
    if (match == null) return date;
    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    String ampm = match.group(3)!;

    if (ampm == "PM" && hour != 12) hour += 12;
    if (ampm == "AM" && hour == 12) hour = 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: const CustomAppBar(isBack: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 0.5,
          shadowColor: Colors.white.withOpacity(0.5),
          color: Colors.white,
          child: Container(
            width: double.infinity,
            height: size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      'book_a_session'.tr,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('date'.tr),
                    const SizedBox(height: 10),
                    DatePickerField(
                      controller: _dateController,
                      selectedDate: _selectedDate,
                      allowedWeekdays: allowedWeekdays,
                      onDatePicked: (pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _dateController.text =
                                "${pickedDate.day.toString().padLeft(2, '0')}/"
                                "${pickedDate.month.toString().padLeft(2, '0')}/"
                                "${pickedDate.year.toString().substring(2)}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    DropdownField(
                      label: 'time',
                      itemList: timeList,
                      defaultValue: timeList.isNotEmpty ? timeList.first : '',
                      onChanged: (value) {
                        setState(() {
                          selectedTime = value!;
                        });
                      },
                    ),
                    DropdownField(
                      label: 'number_of_person',
                      itemList: personNumber,
                      defaultValue: '1',
                      onChanged: (value) {
                        setState(() {
                          selectedPerson = value!;
                        });
                      },
                    ),
                    Text(
                      'additional_request'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    CustomTextField(controller: _requestController, label: ''),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    TermsAndBookingCard(
                      onCancel: () {
                        Get.back();
                      },
                      onSubmit: () {
                        if (_selectedDate == null) {
                          showSnackbar(
                            context,
                            'error'.tr,
                            'please_select_a_date'.tr,
                          );
                        } else if (selectedTime.isEmpty) {
                          showSnackbar(
                            context,
                            'Error',
                            'please_select_a_time'.tr,
                          );
                        } else if (selectedPerson.isEmpty) {
                          showSnackbar(
                            context,
                            'Error',
                            'please_select_numeber_of_persons'.tr,
                          );
                        } else {
                          final bookingDateTime = getCombinedDateTime(
                            _selectedDate!,
                            selectedTime,
                          );
                          apiService.makeBooking(
                            listingId: widget.listingId,
                            bookingDate:
                                bookingDateTime
                                    .toIso8601String(), // <-- The only change
                            bookingHours: selectedTime,
                            numberOfPersons: int.parse(selectedPerson),
                            additionalNote: _requestController.text,
                            context: context,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
