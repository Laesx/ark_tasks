import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/utils/app_routes.dart';
import 'package:ark_jots/utils/consts.dart';
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
              _TaskCheckbox(task.isComplete),
              _TaskDetails(task),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _TaskCheckbox extends StatefulWidget {
  bool isComplete;

  _TaskCheckbox(
    this.isComplete, {
    super.key,
  });

  @override
  State<_TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<_TaskCheckbox> {
  //bool isComplete = ;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      //checkColor: Colors.white,
      value: widget.isComplete,
      onChanged: (bool? value) {
        setState(() {
          widget.isComplete = value!;
        });
      },
    );
  }
}

// Seguramente habrá que hacer esta clase Stateful para poder cambiar el estado de la tarea cuando se actualice
class _TaskDetails extends StatelessWidget {
  final Task task;
  //final String nombre;
  //final int id;

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
        Text(
          task.description ?? "",
          //style: TextStyle(fontSize: 14, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
