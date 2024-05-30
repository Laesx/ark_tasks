import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tools {
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      if (dateTime.year != DateTime.now().year) {
        return DateFormat('H:mm EEE, d LLL y', "es_ES").format(dateTime);
      }
      return DateFormat('H:mm EEE, d LLL', "es_ES").format(dateTime);
    } else {
      return ' ';
    }
  }

  static String formatDate(DateTime? dateTime) {
    if (dateTime != null) {
      if (dateTime.year != DateTime.now().year) {
        return DateFormat('EEE, d LLL y', "es_ES").format(dateTime);
      }
      return DateFormat('EEE, d LLL', "es_ES").format(dateTime);
    } else {
      return ' ';
    }
  }

  // Returns the weekday as a string
  static String getWeekday(DateTime dateTime) {
    return DateFormat('EEEE', "es_ES").format(dateTime);
  }

  static DateTime getTomorrow() {
    return DateTime.now().add(const Duration(days: 1));
  }

  static String timeToText(TimeOfDay? time) {
    if (time != null) {
      if (time.minute >= 10) {
        return '${time.hour}:${time.minute}';
      }
      return '${time.hour}:0${time.minute}';
    } else {
      return '';
    }
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
