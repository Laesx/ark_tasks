import 'package:ark_jots/modules/schedule/schedule_models.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  final List<Schedule> _schedule = [];

  Schedule? selectedSchedule;

  List<Schedule> get schedule => _schedule;

  late String _weekday;

  String get weekday => _weekday;

  set weekday(String value) {
    _weekday = value;
    notifyListeners();
  }

  //Hive boxes and keys.
  static const _scheduleBoxKey = 'schedule';
  static Box _scheduleBox = Hive.box<Schedule>(_scheduleBoxKey);
  // Consider using a LazyBox instead of a Box if it gets too big.
  // Maybe make a separate box for completed schedule.
  // or make it load only the first 10 schedule and load more as the user scrolls.

  ScheduleProvider() {
    // Register Hive adapters.
    Hive.registerAdapter(ScheduleAdapter());

    // Load schedule from Hive.
    Hive.openBox<Schedule>(_scheduleBoxKey).then((box) {
      _schedule.addAll(box.values);
      notifyListeners();
    });

    _weekday = Tools.getWeekday(DateTime.now());
  }

  List<Schedule> get scheduleToday {
    // final now = DateTime.now();
    // final weekday = now.weekday;
    //final weekday = Tools.getWeekday(DateTime.now());
    //print(weekday);
    return _schedule.where((element) {
      return element.weekday.toLowerCase() == _weekday;
    }).toList();
  }

  // BE CAREFUL WITH THIS FUNCTION. IT WILL DELETE ALL TASKS.
  static void deleteScheduleBox() {
    Hive.deleteBoxFromDisk(_scheduleBoxKey);
  }

  void addSchedule(Schedule schedule) {
    _schedule.add(schedule);
    _scheduleBox.add(schedule);
    notifyListeners();
  }

  void removeSchedule(Schedule schedule) {
    schedule.delete();
    _schedule.remove(schedule);
    //_scheduleBox.delete(schedule.key);
    notifyListeners();
  }

  void updateSchedule(Schedule schedule) {
    schedule.save();
    notifyListeners();
  }

  void updateOrCreateSchedule(Schedule? schedule) {
    if (schedule == null) {
      return;
    }
    if (schedule.key == null) {
      addSchedule(schedule);
    } else {
      updateSchedule(schedule);
    }
  }
}
