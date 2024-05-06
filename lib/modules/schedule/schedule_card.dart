import 'package:ark_jots/modules/schedule/schedule_models.dart';
import 'package:ark_jots/modules/schedule/schedule_providers.dart';
import 'package:ark_jots/utils/app_routes.dart';
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
        child: Card(
          margin: const EdgeInsets.only(top: 7, bottom: 7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _ScheduleDetails(schedule),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
