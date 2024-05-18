import 'package:ark_jots/widgets/fields/date_field.dart';
import 'package:ark_jots/widgets/fields/time_field.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ark_jots/utils/tools.dart';

import 'schedule.dart';

// ignore: must_be_immutable
class ScheduleDetailScreen extends StatefulWidget {
  ScheduleDetailScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final schedules = context.watch<ScheduleProvider>();
    final schedule = schedules.selectedSchedule!;

    // This is for the submenu to appear on the center of the screen
    final screenSize = MediaQuery.of(context).size;
    final xOffSet = screenSize.width * 0.25;

    return Scaffold(
        appBar: const TopBar(
          canPop: true,
          title: "Detalles del Horario",
        ),
        body: Hero(
          tag: 'schedule-${schedule.key}',
          child: Material(
            type: MaterialType.transparency,
            child: Form(
              onPopInvoked: (didPop) {
                if (didPop) {
                  if (schedule.name.isNotEmpty) {
                    schedules.updateOrCreateSchedule(schedule);
                  }
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(5),
                children: [
                  //const SizedBox(height: 20),
                  Row(children: [
                    Flexible(
                      child: TextFormField(
                        // style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 250,
                        //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        initialValue: schedule.name,
                        onChanged: (value) => schedule.name = value,
                        onTapOutside: (event) {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus &&
                              currentFocus.focusedChild != null) {
                            currentFocus.focusedChild!.unfocus();
                          }
                        },
                      ),
                    ),
                  ]),
                  // Due Date Menu
                  //WeekdaySubmenu(xOffSet: xOffSet, schedule: schedule),
                  // Row(
                  //   children: [
                  //     const Icon(Icons.calendar_month_outlined),
                  //     const SizedBox(width: 10),
                  //     Text('Día de la semana: ${widget.schedule.weekday}'),
                  //   ],
                  // ),
                  DateField(
                      label: "Día de la semana",
                      value: schedule.weekday,
                      onChanged: (value) {
                        schedule.weekday = value!;
                        schedules.updateOrCreateSchedule(schedule);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: TimeField(
                            label: "Hora Inicio",
                            value: schedule.startTime,
                            onChanged: (value) {
                              schedule.timeStart = Tools.timeToText(value!);
                              schedules.updateOrCreateSchedule(schedule);
                            }),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        fit: FlexFit.loose,
                        child: TimeField(
                            label: "Hora Fin",
                            value: schedule.endTime,
                            onChanged: (value) {
                              schedule.timeEnd = Tools.timeToText(value!);
                              schedules.updateOrCreateSchedule(schedule);
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: schedule.description,
                    onChanged: (value) => schedule.description = value,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Future<String> showWeekdayMenu(context) async {
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
  } else {
    // User canceled the dialog
    print('User canceled the dialog');
    selectedDay = Tools.getWeekday(DateTime.now());
  }
  return selectedDay;
}

class WeekdaySubmenu extends StatefulWidget {
  const WeekdaySubmenu({
    super.key,
    required this.xOffSet,
    required this.schedule,
  });

  final double xOffSet;
  final Schedule schedule;

  @override
  State<WeekdaySubmenu> createState() => _WeekdaySubmenuState();
}

class _WeekdaySubmenuState extends State<WeekdaySubmenu> {
  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      alignmentOffset: Offset(widget.xOffSet, 0),
      menuChildren: [
        MenuItemButton(
            leadingIcon: const Icon(Icons.calendar_today),
            child: Text('Hoy (${Tools.getWeekday(DateTime.now())})'),
            onPressed: () {
              widget.schedule.weekday = Tools.getWeekday(DateTime.now());
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.calendar_today),
            child: Text('Mañana (${Tools.getWeekday(Tools.getTomorrow())})'),
            onPressed: () {
              widget.schedule.weekday = Tools.getWeekday(Tools.getTomorrow());
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.edit_calendar_outlined),
            child: const Text("Elegir fecha"),
            onPressed: () {
              showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100))
                  .then((value) {
                if (value != null) {
                  widget.schedule.weekday = Tools.getWeekday(value);
                  setState(() {});
                }
              });
              //submenuButtonKey.currentState!.closeMenu();
            }),
      ],
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined),
          const SizedBox(width: 10),
          Text('Día de la semana: ${widget.schedule.weekday}'),
        ],
      ),
    );
  }
}
