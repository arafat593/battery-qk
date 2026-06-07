import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Map<String, int> weekDaysMap = {
  // English
  'Mon': DateTime.monday,
  'Tue': DateTime.tuesday,
  'Wed': DateTime.wednesday,
  'Thu': DateTime.thursday,
  'Fri': DateTime.friday,
  'Sat': DateTime.saturday,
  'Sun': DateTime.sunday,
  // Arabic (common full names)
  'الاثنين': DateTime.monday,
  'الإثنين': DateTime.monday, // some will use this
  'الثلاثاء': DateTime.tuesday,
  'الأربعاء': DateTime.wednesday,
  'الخميس': DateTime.thursday,
  'الجمعة': DateTime.friday,
  'السبت': DateTime.saturday,
  'الأحد': DateTime.sunday,
};

List<int> parseAllowedWeekdays(String openingHours) {
  String rangePart = openingHours.split(':').first.trim();

  // Remove Arabic "من" if present
  if (rangePart.startsWith("من")) {
    rangePart = rangePart.replaceFirst("من", "").trim();
  }

  // Remove any extra spaces or Arabic definite articles (like "ال")
  rangePart = rangePart
      .replaceAll("–", "-")
      .replaceAll("—", "-")
      .replaceAll("الى", "-");
  // Some providers may use different dash characters

  if (rangePart.contains('-')) {
    final parts = rangePart.split('-').map((e) => e.trim()).toList();
    final start = weekDaysMap[parts[0]];
    final end = weekDaysMap[parts[1]];
    if (start == null || end == null) return [];

    List<int> allowed = [];
    int current = start;
    while (true) {
      allowed.add(current);
      if (current == end) break;
      current = current % 7 + 1;
    }
    return allowed;
  } else {
    final single = weekDaysMap[rangePart];
    return single != null ? [single] : [];
  }
}

List<String> generateTimeSlots(String openingHours) {
  try {
    final timePart = openingHours.split(':').last.trim();
    final parts = timePart.split('-').map((s) => s.trim()).toList();
    if (parts.length != 2) return [];
    final start = parts[0];
    final end = parts[1];
    TimeOfDay startTime = parseTime(start);
    TimeOfDay endTime = parseTime(end);

    int hour = startTime.hour;
    int endHour = endTime.hour;
    if (end.contains('PM') && endHour < 12) endHour += 12;
    if (start.contains('PM') && hour < 12) hour += 12;

    List<String> slots = [];
    for (int h = hour; h <= endHour; h++) {
      slots.add(formatTimeLabel(h));
    }
    return slots;
  } catch (_) {
    return [];
  }
}

String normalizeAmPm(String s) {
  s = s.replaceAll(' ', '').replaceAll('ـ', '');
  if (s.contains('صباحاً') || s.contains('صباحا') || s.contains('ص'))
    return 'AM';
  if (s.contains('مساءً') || s.contains('مساءا') || s.contains('م'))
    return 'PM';
  return s;
}

TimeOfDay parseTime(String s) {
  final match = RegExp(
    r'(\d{1,2})(?::(\d{2}))?\s*([AP]M|صباحاً|صباحا|مساءً|مساءا|ص|م)',
  ).firstMatch(s);
  if (match == null) return TimeOfDay(hour: 9, minute: 0);

  int hour = int.parse(match.group(1)!);
  int minute = match.group(2) != null ? int.parse(match.group(2)!) : 0;
  String ampm = normalizeAmPm(match.group(3)!);

  if (ampm == "PM" && hour != 12) hour += 12;
  if (ampm == "AM" && hour == 12) hour = 0;

  return TimeOfDay(hour: hour, minute: minute);
}

String formatTimeLabel(int hour24) {
  int hour = hour24 % 12 == 0 ? 12 : hour24 % 12;
  bool isAM = hour24 < 12;
  final isArabic = Get.locale?.languageCode == 'ar';

  String ampm;
  if (isArabic) {
    ampm = isAM ? 'صباحاً' : 'مساءً';
  } else {
    ampm = isAM ? 'AM' : 'PM';
  }
  return "$hour:00 $ampm";
}

DateTime findNextAllowedDate(List<int> allowedWeekdays, DateTime from) {
  for (int i = 0; i < 7; i++) {
    final date = from.add(Duration(days: i));
    if (allowedWeekdays.contains(date.weekday)) {
      return date;
    }
  }
  return from;
}
