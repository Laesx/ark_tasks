import 'package:ark_jots/modules/schedule/schedule_card.dart';
import 'package:ark_jots/modules/schedule/schedule_models.dart';
import 'package:ark_jots/widgets/layouts/floating_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatelessWidget {
  final List<Schedule> schedule = [
    Schedule(name: "Lesson 1", timeStart: "08:00", timeEnd: "09:00"),
    Schedule(name: "Lesson 2", timeStart: "09:00", timeEnd: "10:00"),
    Schedule(name: "Lesson 3", timeStart: "10:00", timeEnd: "11:00"),
    Schedule(name: "Lesson 4", timeStart: "11:00", timeEnd: "12:00"),
  ];

  final ScrollController scrollCtrl;

  ScheduleView(this.scrollCtrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      floatingBar: FloatingBar(scrollCtrl: scrollCtrl, children: [
        ActionButton(
            icon: Icons.edit_attributes_outlined,
            tooltip: "New Note",
            onTap: () => null)
      ]),
      child: Padding(
        // This padding should be done more elegantly so I don't have to put it everywhere
        padding: const EdgeInsets.only(top: TopBar.height),
        child: ListView.builder(
          itemCount: schedule.length,
          itemBuilder: (context, index) {
            //final task = schedule[index];
            return ScheduleCard(schedule: schedule[index]);
          },
        ),
      ),
    );
  }
}
