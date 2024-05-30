import 'package:ark_jots/modules/schedule/schedule_models.dart';
import 'package:ark_jots/modules/schedule/schedule_providers.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final schedules = context.watch<ScheduleProvider>();

    return Hero(
      tag: 'schedule-${schedule.key}',
      child: GestureDetector(
        onTap: () {
          schedules.selectedSchedule = schedule;
          Navigator.pushNamed(context, "/schedule");
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text("Borrar Horario"),
                    content: const Text(
                        "¿Estás seguro de que quieres borrar este horario?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          schedules.removeSchedule(schedule);
                          Navigator.pop(context);
                        },
                        child: const Text("Borrar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                    ],
                  ));
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            //margin: const EdgeInsets.only(top: 7, bottom: 7),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _ScheduleColor(schedule),
                  _ScheduleDetails(schedule),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleColor extends StatelessWidget {
  final Schedule schedule;

  const _ScheduleColor(
    this.schedule, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: schedule.colorValue,
          borderRadius: Consts.borderRadiusMax,
        ),
        // color: _stringtoColor(schedule.color ?? "FF0000"),
      ),
    );
  }
}

Color _stringtoColor(String color) {
  return Color(int.parse(color, radix: 16));
}

class _ScheduleDetails extends StatelessWidget {
  final Schedule schedule;

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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          "${schedule.timeStart} - ${schedule.timeEnd}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        if (schedule.description != null) ...[
          const SizedBox(height: 5),
          Text(
            schedule.description ?? "",
            //style: TextStyle(fontSize: 14, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ]
      ],
    );
  }
}
