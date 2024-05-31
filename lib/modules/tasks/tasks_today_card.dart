import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksTodayCard extends StatelessWidget {
  const TasksTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        // print(index);
        // print("Task: ${tasksProvider.tasks[index].title}");
        if (tasks[index].dueDate != null &&
            tasks[index].dueDate!.difference(DateTime.now()).inDays <= 5 &&
            tasks[index].isComplete == false) {
          // print("Task Cards: ${tasksProvider.tasks[index].title}");
          return TaskCard(task: tasks[index]);
        }
        // print(index);
        return Container();
      },
      //itemCount: 10,
    );

    // return Column(
    //   children: tasks
    //       .where((task) {
    //         return task.dueDate != null &&
    //             task.dueDate!.day == DateTime.now().day;
    //       })
    //       .map((task) => TaskCard(task: task))
    //       .toList(),
    // );
  }
}
