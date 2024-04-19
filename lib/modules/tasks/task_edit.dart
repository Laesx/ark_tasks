import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    //final tasks = context.watch(tasksProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(task.title),
        ),
        body: Center(child: Text(task.description ?? '')));
  }
}
