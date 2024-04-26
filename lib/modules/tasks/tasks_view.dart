import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:ark_jots/widgets/layouts/floating_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TasksView extends StatefulWidget {
  final ScrollController scrollCtrl;

  TasksView(this.scrollCtrl, {super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return TabScaffold(
      floatingBar: FloatingBar(scrollCtrl: widget.scrollCtrl, children: [
        ActionButton(
            icon: Icons.note_add_outlined,
            tooltip: "New Note",
            onTap: () {
              Task task = Task(
                  title: '',
                  createdAt: DateTime.now(),
                  lastUpdated: DateTime.now());
              taskProvider.updateOrCreateTask(task);
              taskProvider.selectedTask = task;
              context.push('/task');
            }),
      ]),
      topBar: TopBar(
        canPop: false,
        title: "Tasks",
        trailing: [
          SubmenuButton(menuChildren: [
            MenuItemButton(
              child: const Text("Sort by date"),
              onPressed: () {
                taskProvider.tasks.sort((a, b) {
                  if (a.dueDate == null || b.dueDate == null) {
                    return -1;
                  } else {
                    return a.dueDate!.compareTo(b.dueDate!);
                  }
                  //return a.dueDate.compareTo(b.dueDate);
                });
                setState(() {});
              },
            ),
          ], child: Icon(Icons.sort_outlined))
        ],
      ),
      child: Padding(
        // This padding should be done more elegantly so I don't have to put it everywhere
        padding: const EdgeInsets.only(top: TopBar.height),
        child: ListView.builder(
          itemCount: taskProvider.tasks.length,
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];
            return TaskCard(task: task);
          },
        ),
      ),
    );
  }
}
