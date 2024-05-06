import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:ark_jots/utils/app_routes.dart';
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
        padding: const EdgeInsets.all(5),
        child: Card(
          //margin: const EdgeInsets.only(top: 7, bottom: 7),
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TaskCheckbox(task),
                _TaskDetails(task),
              ],
            ),
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
    //final tasksProvider = context.watch<TaskProvider>();
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
          });
          widget.task.save();
          // TODO: Animation
          // This below works since it notifies the observers but it
          // doesn't show the checkmark animation, to check later.
          //tasksProvider.updateOrCreateTask(widget.task);
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
    // Expanded here makes the text properly wrap around
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: task.isComplete
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
            maxLines: 20,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              if (task.dueDate != null) ...[
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  task.dueDate != null
                      ? Tools.formatDateTime(task.dueDate!)
                      : "",
                ),
              ],

              // This can probably be done better in case there's going to
              //be multiple sections of information
              if (task.subtasks.isNotEmpty && task.dueDate != null)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    "·",
                    textAlign: TextAlign.center,
                  ),
                ),

              if (task.subtasks.isNotEmpty) Text(getSubtasksString()),
            ],
          ),
        ],
      ),
    );
  }

  String getSubtasksString() {
    int completed = task.subtasks.where((subtask) => subtask.isComplete).length;
    int total = task.subtasks.length;

    return "$completed de $total";
    //return task.subtasks.map((subtask) => subtask.title).join(", ");
  }
}
