import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

/*

import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  Task? selectedTask;

  List<Task> get tasks => _tasks;

  //Hive boxes and keys.
  static const _tasksBoxKey = 'tasks';
  static LazyBox _tasksBox = Hive.lazyBox<Task>(_tasksBoxKey);


  TaskProvider() {
    // Load tasks from Hive.
    Hive.openLazyBox<Task>(_tasksBoxKey).then((box) {
      _tasks.addAll(box.values);
      notifyListeners();
    });
  }

  void addTask(Task task) {
    _tasks.add(task);
    //_tasksBox.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
*/
