import 'package:ark_jots/models/task.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 52, 52, 52),
            // o poner el Borde Simple...
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
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
      checkColor: Colors.white,
      value: widget.isComplete,
      onChanged: (bool? value) {
        setState(() {
          widget.isComplete = value!;
        });
      },
    );
  }
}

class _TagDescription extends StatelessWidget {
  final String descripcion;

  const _TagDescription({
    super.key,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      child: Text(
        '$descripcion€',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
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
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          task.description ?? "",
          style: TextStyle(fontSize: 14, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
