import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/widgets/layouts/floating_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:flutter/material.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:provider/provider.dart';

class TasksView extends StatelessWidget {
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

  final ScrollController scrollCtrl;

  TasksView(this.scrollCtrl, {super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TaskProvider>();

    return TabScaffold(
      floatingBar: FloatingBar(scrollCtrl: scrollCtrl, children: [
        ActionButton(
            icon: Icons.note_add_outlined,
            tooltip: "New Note",
            onTap: () => null)
      ]),
      topBar: TopBar(
        canPop: false,
        title: "Tasks",
      ),
      child: Padding(
        // This padding should be done more elegantly so I don't have to put it everywhere
        padding: const EdgeInsets.only(top: TopBar.height),
        child: ListView.builder(
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            final task = state.tasks[index];
            return TaskCard(task: task);
          },
        ),
      ),
    );
  }
}