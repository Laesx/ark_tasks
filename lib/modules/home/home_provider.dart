import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  ColorScheme? systemLightScheme;
  ColorScheme? systemDarkScheme;

  void cacheSystemColorSchemes(
    ColorScheme? systemLightScheme,
    ColorScheme? systemDarkScheme,
  ) {
    this.systemLightScheme = systemLightScheme;
    this.systemDarkScheme = systemDarkScheme;
  }
}

enum HomeTab {
  home,
  //missions,
  tasks,
  schedule,
  // notes,
  profile;

  String get title => switch (this) {
        home => 'Inicio',
        //missions => 'Missions',
        tasks => 'Tareas',
        schedule => 'Horario',
        // notes => 'Notas',
        profile => 'Perfil',
      };

  IconData get iconData => switch (this) {
        home => Icons.home_outlined,
        //missions => Icons.people_alt_outlined,
        tasks => Icons.task_alt_outlined,
        schedule => Icons.schedule_outlined,
        // notes => Icons.note_outlined,
        profile => Icons.person_outlined,
      };
}
