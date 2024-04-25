import 'package:ark_jots/modules/schedule/schedule_models.dart';
import 'package:ark_jots/modules/schedule/schedule_providers.dart';
import 'package:ark_jots/utils/app_routes.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();

    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, '/task/${task.id}');
        // We select the task here and push the route to the task details screen
        scheduleProvider.selectedSchedule = schedule;
        context.push(AppRoutes.schedule());
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
              //TaskCheckbox(task.isComplete),
              //_TaskDetails(task),
              _ScheduleDetails(schedule),
            ],
          ),
        ),
      ),
    );
  }
}

// Seguramente habrá que hacer esta clase Stateful para poder cambiar el estado de la tarea cuando se actualice
class _ScheduleDetails extends StatelessWidget {
  final Schedule schedule;
  //final String nombre;
  //final int id;

  const _ScheduleDetails(
    this.schedule, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          schedule.description ?? "",
          //style: TextStyle(fontSize: 14, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
