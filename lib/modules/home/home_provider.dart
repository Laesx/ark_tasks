import 'package:flutter/material.dart';

enum HomeTab {
  home,
  //missions,
  tasks,
  schedule,
  notes,
  settings;

  String get title => switch (this) {
        home => 'Inicio',
        //missions => 'Missions',
        tasks => 'Tareas',
        schedule => 'Horario',
        notes => 'Notas',
        settings => 'Opciones',
      };

  IconData get iconData => switch (this) {
        home => Icons.home,
        //missions => Icons.people_alt_outlined,
        tasks => Icons.task_alt_outlined,
        schedule => Icons.schedule_outlined,
        notes => Icons.note_outlined,
        settings => Icons.settings_outlined,
      };
}
