import 'package:ark_jots/modules/schedule/schedule_models.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            //_TaskCheckbox(schedule.isComplete),
            //_TaskDetails(schedule),
          ],
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