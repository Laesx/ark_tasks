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
}
