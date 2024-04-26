import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:ark_jots/utils/app_routes.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>();

    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, '/task/${task.id}');
        // We select the task here and push the route to the task details screen
        tasks.selectedTask = task;
        context.push(AppRoutes.task());
      },
      onLongPress: () {
        tasks.selectedTask = task;
        context.push(AppRoutes.task());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: double.infinity,
          height: 70,
          margin: const EdgeInsets.only(top: 7, bottom: 7),
          decoration: BoxDecoration(
              // TODO: Remove this color and use the theme color
              color: const Color.fromARGB(255, 52, 52, 52),
              borderRadius: Consts.borderRadiusMin,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  offset: Offset(0, 7),
                  blurRadius: 10,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TaskCheckbox(task),
              _TaskDetails(task),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TaskCheckbox extends StatefulWidget {
  Task task;
  Subtask? subtask;

  TaskCheckbox(
    this.task, {
    this.subtask,
    super.key,
  });

  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.subtask != null ? 1 : 1.15,
      child: Checkbox(
        value: widget.subtask != null
            ? widget.subtask!.isComplete
            : widget.task.isComplete,
        onChanged: (bool? value) {
          setState(() {
            if (widget.subtask != null) {
              widget.subtask!.isComplete = value!;
            } else {
              widget.task.isComplete = value!;
            }
            // Saves the task to the box when the checkbox is toggled
            widget.task.save();
          });
        },
      ),
    );
  }
}

// Seguramente habrá que hacer esta clase Stateful para poder cambiar el estado de la tarea cuando se actualice
class _TaskDetails extends StatelessWidget {
  final Task task;

  const _TaskDetails(
    this.task, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            if (task.dueDate != null) ...[
              const Icon(
                Icons.calendar_today_outlined,
                size: 12,
              ),
              const SizedBox(width: 5),
              Text(
                task.dueDate != null ? Tools.formatDateTime(task.dueDate!) : "",
              ),
            ],
            // Row(
            //   children: [
            //     const Icon(
            //       Icons.calendar_today_outlined,
            //       size: 12,
            //     ),
            //     const SizedBox(width: 5),
            //     Text(
            //       task.dueDate != null
            //           ? Tools.formatDateTime(task.dueDate!)
            //           : "",
            //     ),
            //   ],
            // ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "·",
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              task.priority.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
