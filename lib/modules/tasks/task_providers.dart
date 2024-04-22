import 'package:ark_jots/models/priority.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  Task? selectedTask;

  List<Task> get tasks => _tasks;

  //Hive boxes and keys.
  static const _tasksBoxKey = 'tasks';
  static Box _tasksBox = Hive.box<Task>(_tasksBoxKey);
  // Consider using a LazyBox instead of a Box if it gets too big.
  // Maybe make a separate box for completed tasks.
  // or make it load only the first 10 tasks and load more as the user scrolls.

  TaskProvider() {
    // Register Hive adapters.
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(PriorityAdapter());
    // Load tasks from Hive.
    Hive.openBox<Task>(_tasksBoxKey).then((box) {
      _tasks.addAll(box.values);
      notifyListeners();
    });
  }

  void addTask(Task task) {
    _tasks.add(task);
    _tasksBox.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    task.delete();
    _tasks.remove(task);
    //_tasksBox.delete(task.key);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.save();
    notifyListeners();
  }

  void updateOrCreateTask(Task? task) {
    if (task == null) {
      return;
    }
    if (task.key == null) {
      addTask(task);
    } else {
      updateTask(task);
    }
  }
}
