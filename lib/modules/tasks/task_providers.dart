import 'dart:math';

import 'package:ark_jots/models/priority.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/services/ai_service.dart';
import 'package:ark_jots/services/firestore_service.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  Task? selectedTask;

  List<Task> get tasks => _tasks;

  //Hive boxes and keys.
  static const _tasksBoxKey = 'tasks';
  static final Box _tasksBox = Hive.box<Task>(_tasksBoxKey);
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
      AiService().parsedTasks = overdueAndTwoWeeksTasks;
      // print("Tasks loaded from Hive: ${_tasks.length}");
      notifyListeners();
    });
  }

  // Download the Tasks from Firestore.
  void downloadTasks() async {
    // Download tasks from the server.
    List<Task> tasks = await FirestoreService().getUserTasks();

    for (var task in tasks) {
      if (_tasks.any((e) => e.id == task.id)) {
        int index = _tasks.indexWhere((t) => t.id == task.id);
        _tasks[index].updateWith(task);
        _tasks[index].save();
      } else {
        addTask(task);
      }
    }

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

  // This will give a String of all the overdue tasks, and all the tasks 2 weeks from now separated by a new line.
  String get overdueAndTwoWeeksTasks {
    DateTime now = DateTime.now();
    DateTime twoWeeksFromNow = now.add(Duration(days: 14));

    List<Task> twoWeeksTasks = _tasks.where((task) {
      if (task.dueDate != null) {
        if (task.dueDate!.isBefore(now)) {
          return true;
        } else if (task.dueDate!.isAfter(now) &&
            task.dueDate!.isBefore(twoWeeksFromNow)) {
          return true;
        }
        // return task.dueDate!.isAfter(now) && task.dueDate!.isBefore(twoWeeksFromNow);
      }
      return false;
    }).toList();

    String tasksSummary = twoWeeksTasks.map((e) {
      return e.title +
          (e.dueDate != null ? " - ${Tools.formatDate(e.dueDate)}" : "");
    }).join('\n');

    // print(tasksSummary);

    return tasksSummary;
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
    task.lastUpdated = DateTime.now();
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

  // Section to task sort
  TaskSort _sort = TaskSort.dueDate;

  TaskSort get sort => _sort;

  set sort(TaskSort value) {
    _sort = value;
    _sortTasks();
    //notifyListeners();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      switch (sort) {
        case TaskSort.dueDate:
          if (a.dueDate == null && b.dueDate == null) {
            // return -1;
            return 1;
          } else if (a.dueDate == null) {
            return 1;
          } else if (b.dueDate == null) {
            return -1;
          } else {
            return a.dueDate!.compareTo(b.dueDate!);
          }
        case TaskSort.lastUpdated:
          return a.lastUpdated.compareTo(b.lastUpdated);
        case TaskSort.created:
          return a.createdAt.compareTo(b.createdAt);
        case TaskSort.title:
          return a.title.compareTo(b.title);
        default:
          return 0;
      }
    });
    notifyListeners();
  }
}

enum TaskSort { dueDate, lastUpdated, created, title }

extension TaskSortExtension on TaskSort {
  String get name {
    switch (this) {
      case TaskSort.dueDate:
        return "Due Date";
      case TaskSort.lastUpdated:
        return "Last Updated";
      case TaskSort.created:
        return "Created";
      case TaskSort.title:
        return "Title";
    }
  }

  int compare(Task a, Task b) {
    switch (this) {
      case TaskSort.dueDate:
        if (a.dueDate == null || b.dueDate == null) {
          return -1;
        } else {
          return a.dueDate!.compareTo(b.dueDate!);
        }
      case TaskSort.lastUpdated:
        return a.lastUpdated.compareTo(b.lastUpdated);
      case TaskSort.created:
        return a.createdAt.compareTo(b.createdAt);
      case TaskSort.title:
        return a.title.compareTo(b.title);
    }
  }
}
