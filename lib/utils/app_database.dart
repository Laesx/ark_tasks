import 'dart:async';
import 'package:ark_jots/modules/tasks/task_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/priority.dart';
import '../modules/tasks/task_model.dart';

part 'app_database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, PriorityConverter])
@Database(version: 1, entities: [Task])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
}

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class PriorityConverter extends TypeConverter<Priority, int> {
  @override
  Priority decode(int databaseValue) {
    return Priority.fromValue(databaseValue);
  }

  @override
  int encode(Priority value) {
    return value.index;
  }
}
