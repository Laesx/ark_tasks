import 'dart:math';

import 'package:ark_jots/modules/tasks/tasks.dart';

class DemoStuff {
  static const String demoText = 'Demo Text';

  final List<Task> demoTasks = [
    Task(
      id: 1,
      title: 'Task 1',
      description: "Description 1",
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    ),
    Task(
      id: 2,
      title: 'Task 2',
      description: 'Description 2',
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      isComplete: true,
    ),
    Task(
      id: 3,
      title: 'Task 3',
      description: 'Description 3',
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    ),
  ];

  void fillBoxWithDemoTasks(context) {
    final random = Random();

    //final tasks = Provider.of<TaskProvider>(context, listen: false);

    //List<Task> tasks = [];
    for (int i = 0; i < 50; i++) {
      Task task = Task(
        title: 'Task $i',
        description: 'Description $i',
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        dueDate: randomThisMonthDate,
        isComplete: random.nextBool(),
      );

      //tasks.updateOrCreateTask(task);

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
