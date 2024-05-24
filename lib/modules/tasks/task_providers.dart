import 'dart:math';

import 'package:ark_jots/models/priority.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/services/firestore_service.dart';
import 'package:hive/hive.dart';

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
    Hive.registerAdapter(SubtaskAdapter());
    // Load tasks from Hive.
    Hive.openBox<Task>(_tasksBoxKey).then((box) {
      _tasks.addAll(box.values);
      notifyListeners();
    });
  }

  // Download the Tasks from Firestore.
  void downloadTasks() async {
    // Download tasks from the server.
    List<Task> tasks = await FirestoreService().getUserTasks();
    // _tasksBox.clear();
    // _tasks.clear();

    // for (var task in tasks) {
    //   addTask(task);
    // }

    for (var task in tasks) {
      if (_tasks.any((e) => e.id == task.id)) {
        int index = _tasks.indexWhere((t) => t.id == task.id);
        //_tasksBox(index, task);
        //_tasks[index].delete();
        _tasks[index].updateWith(task);
        _tasks[index].save();
      } else {
        addTask(task);
        // _tasks.add(task);
        // _tasksBox.add(task);
      }
    }

    // _tasksBox.clear();
    // for (var task in _tasks) {
    //   _tasksBox.add(task);
    // }

    notifyListeners();
  }

  DateTime? get lastUpdated {
    if (_tasks.isEmpty) {
      return null;
    }
    return _tasks.map((e) => e.lastUpdated).reduce((a, b) {
      if (a.isAfter(b)) {
        return a;
      }
      return b;
    });
  }

  // BE CAREFUL WITH THIS FUNCTION. IT WILL DELETE ALL TASKS.
  static void deleteTasksBox() {
    Hive.deleteBoxFromDisk(_tasksBoxKey);
  }

  List<Task> getTasksByPriority(Priority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<Task> getTasksByDate(DateTime date) {
    return _tasks.where((task) {
      if (task.dueDate != null) {
        return task.dueDate!.isAtSameMomentAs(date);
      }
      return false;
    }).toList();
  }

  // TODO: Test this function
  List<Task> getLastTasksOrderedByDate(int count) {
    return _tasks.where((task) => task.dueDate != null).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!))
      ..take(count).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _tasksBox.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    try {
      // _tasksBox.delete(task.key);
      task.delete();
    } catch (e) {
      print(e);
    }
    //task.delete();
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

  void fillBoxWithDemoTasks() {
    final random = Random();

    //List<Task> tasks = [];
    for (int i = 0; i < 50; i++) {
      Task task = Task(
        title: 'Task $i',
        description: 'Description $i',
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        dueDate: randomDate(oneMonthAgo, oneMonthLater),
        isComplete: random.nextBool(),
      );

      updateOrCreateTask(task);

      print("${task.title} added to tasks.");
      //tasks.add(demoTasks[i]);
    }

    //return demoTasks;
  }

  static DateTime now = DateTime.now();
  static DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
  static DateTime oneMonthLater = DateTime(now.year, now.month + 1, now.day);

  DateTime randomPastMonthDate = randomDate(oneMonthAgo, now);
  DateTime randomThisMonthDate =
      randomDate(DateTime(now.year, now.month, 1), now);
  DateTime randomNextMonthDate = randomDate(now, oneMonthLater);

  static DateTime randomDate(DateTime startDate, DateTime endDate) {
    final random = Random();

    // Calculate the difference between the start and end dates
    int difference = endDate.difference(startDate).inDays;

    // Generate a random number of days to add to the start date
    int daysToAdd = random.nextInt(difference);

    // Add the random number of days to the start date
    return startDate.add(Duration(days: daysToAdd));
  }
}
