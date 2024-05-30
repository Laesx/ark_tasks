import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:ark_jots/widgets/layouts/floating_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksView extends StatefulWidget {
  final ScrollController scrollCtrl;

  const TasksView(this.scrollCtrl, {super.key});

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
    const dividerMarker = Divider();
    // Combine the incomplete and completed tasks into a single list
    final allTasks = []
      ..addAll(incompleteTasks)
      ..add(dividerMarker)
      ..addAll(completedTasks);

    final topOffset = MediaQuery.paddingOf(context).top + TopBar.height + 10;

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
              //taskProvider.updateOrCreateTask(task);
              taskProvider.selectedTask = task;
              Navigator.pushNamed(context, "/task");
              //context.push('/task');
            }),
      ]),
      topBar: TopBar(
        canPop: false,
        title: "Tareas",
        trailing: [
          SubmenuButton(menuChildren: [
            MenuItemButton(
              child: const Text("Ordenar por Titulo"),
              onPressed: () {
                taskProvider.sort = TaskSort.title;
                // setState(() {});
              },
            ),
            MenuItemButton(
              child: const Text("Ordenar por Fecha de Vencimiento"),
              onPressed: () {
                taskProvider.sort = TaskSort.dueDate;
                // setState(() {});
              },
            ),
            MenuItemButton(
              child: const Text("Ordenar por Fecha de Creación"),
              onPressed: () {
                taskProvider.sort = TaskSort.created;
                // setState(() {});
              },
            ),
            MenuItemButton(
              child: const Text("Ordenar por Última Modificación"),
              onPressed: () {
                taskProvider.sort = TaskSort.lastUpdated;
                // setState(() {});
              },
            ),
          ], child: const Icon(Icons.sort_outlined))
        ],
      ),
      child: ListView.builder(
        //TODO: Adjust the top padding to account for the top bar
        padding: EdgeInsets.only(top: topOffset, bottom: 100),
        shrinkWrap: true,
        itemCount: allTasks.length,
        itemBuilder: (context, index) {
          // All this uglyness is to add a Divider as the 1st item
          // and between the incomplete and completed tasks
          // if (index == 0) {
          //   return const Divider(height: 30);
          //}
          if (allTasks[index] is Divider) {
            return const Divider();
          } else if (allTasks[index] is Task) {
            final task = allTasks[index];
            return TaskCard(task: task);
          }
          return null;
          //final task = taskProvider.tasks[index];
          //return TaskCard(task: task);
        },
      ),
    );
  }
}
