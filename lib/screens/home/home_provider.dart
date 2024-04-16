import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum HomeTab {
  home,
  students,
  calculators,
  something,
  settings;

  String get title => switch (this) {
        home => 'Home',
        students => 'Students',
        calculators => 'Calculators',
        something => 'NIL',
        settings => 'Settings',
      };

  IconData get iconData => switch (this) {
        home => Icons.home,
        students => Icons.people_alt_outlined,
        calculators => Icons.calculate_outlined,
        something => Icons.abc_outlined,
        settings => Icons.settings_outlined,
      };
}
