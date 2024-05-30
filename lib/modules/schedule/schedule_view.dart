import 'package:ark_jots/modules/schedule/schedule.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:ark_jots/widgets/layouts/floating_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleView extends StatelessWidget {
  final ScrollController scrollCtrl;

  ScheduleView(this.scrollCtrl, {super.key});

  @override
  Widget build(BuildContext context) {
    //String weekday = Tools.getWeekday(DateTime.now());

    final schedules = context.watch<ScheduleProvider>();

    return TabScaffold(
      topBar: TopBar(
        canPop: false,
        title: "Horario - ${schedules.weekday.capitalize()}",
        trailing: [
          IconButton(
              onPressed: () async {
                final List<String> weekdays = [
                  'lunes',
                  'martes',
                  'miércoles',
                  'jueves',
                  'viernes',
                  'sábado',
                  'domingo'
                ];
                var selectedDay = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Selecciona el día de la semana'),
                      children: weekdays.map((String day) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, day);
                          },
                          child: Text(day.capitalize()),
                        );
                      }).toList(),
                    );
                  },
                );

                if (selectedDay != null) {
                  // Use the selected day
                  print('Selected day: $selectedDay');
                  schedules.weekday = selectedDay;
                }
              },
              icon: Icon(Icons.calendar_month))
        ],
      ),
      floatingBar: FloatingBar(scrollCtrl: scrollCtrl, children: [
        ActionButton(
            icon: Icons.edit_calendar_outlined,
            tooltip: "Agregar Horario",
            onTap: () {
              Schedule schedule = Schedule(
                  name: '',
                  timeStart: '10:00',
                  timeEnd: '10:00',
                  weekday: schedules.weekday);
              schedules.selectedSchedule = schedule;
              Navigator.pushNamed(context, "/schedule");
            })
      ]),
      child: Padding(
        // This padding should be done more elegantly so I don't have to put it everywhere
        padding: const EdgeInsets.only(top: TopBar.height),
        child: ListView.builder(
          itemCount: schedules.scheduleToday.length,
          itemBuilder: (context, index) {
            //final task = schedule[index];
            return ScheduleCard(schedule: schedules.scheduleToday[index]);
          },
        ),
      ),
    );
  }
}
