import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tools {
  static String formatDateTime(DateTime? dateTime) {
    return dateTime != null
        ? DateFormat('EEE, d LLL', "es_ES").format(dateTime)
        : " ";
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
