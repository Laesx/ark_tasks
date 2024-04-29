import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:ark_jots/widgets/layouts/floating_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    // TODO: This probably makes performance absolutely horrible
    final incompleteTasks =
        taskProvider.tasks.where((task) => !task.isComplete).toList();
    final completedTasks =
        taskProvider.tasks.where((task) => task.isComplete).toList();
    // Create a special marker object for the divider
    final dividerMarker = Divider();
    // Combine the incomplete and completed tasks into a single list
    final allTasks = []
      ..addAll(incompleteTasks)
      ..add(dividerMarker)
      ..addAll(completedTasks);

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
          shrinkWrap: true,
          itemCount: allTasks.length + 1,
          itemBuilder: (context, index) {
            // All this uglyness is to add a Divider as the 1st item
            // and between the incomplete and completed tasks
            if (index == 0) {
              return const Divider(height: 30);
            }
            if (allTasks[index - 1] is Divider) {
              return const Divider();
            } else if (allTasks[index - 1] is Task) {
              final task = allTasks[index - 1];
              return TaskCard(task: task);
            }
            return null;
            //final task = taskProvider.tasks[index];
            //return TaskCard(task: task);
          },
        ),
      ),
    );
  }
}
