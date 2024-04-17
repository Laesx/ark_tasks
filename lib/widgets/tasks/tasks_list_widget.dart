import 'package:ark_jots/widgets/tasks/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:ark_jots/models/task.dart';

class TasksListWidget extends StatelessWidget {
  final List<Task> tasks = [
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

  TasksListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskWidget(task: task);
      },
    );
  }
}
