import 'package:flutter/material.dart';

enum HomeTab {
  home,
  students,
  tasks,
  schedule,
  settings;

  String get title => switch (this) {
        home => 'Home',
        students => 'Students',
        tasks => 'Tasks',
        schedule => 'Schedule',
        settings => 'Settings',
      };

  IconData get iconData => switch (this) {
        home => Icons.home,
        students => Icons.people_alt_outlined,
        tasks => Icons.task_alt_outlined,
        schedule => Icons.schedule_outlined,
        settings => Icons.settings_outlined,
      };
}
