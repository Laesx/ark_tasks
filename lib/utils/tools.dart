//import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tools {
  static String formatDateTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('EEE, d/M').format(dateTime) : " ";
  }

  // Returns the weekday as a string
  static String getWeekday(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }

  static DateTime getTomorrow() {
    return DateTime.now().add(const Duration(days: 1));
  }
}
