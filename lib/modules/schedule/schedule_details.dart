import 'package:ark_jots/widgets/fields/weekday_field.dart';
import 'package:ark_jots/widgets/fields/time_field.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: WeekdayField(
                            label: "Día de la semana",
                            value: schedule.weekday,
                            onChanged: (value) {
                              schedule.weekday = value!;
                              schedules.updateOrCreateSchedule(schedule);
                            }),
                      ),
                      ColorSelector(schedule: schedule, schedules: schedules),
                    ],
                  ),
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
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
    required this.schedule,
    required this.schedules,
  });

  final Schedule schedule;
  final ScheduleProvider schedules;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final List<Color> colors = [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.brown,
          Colors.grey,
          Colors.white,
        ];

        Color? selectedColor = await showDialog<Color>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Selecciona un color para el horario'),
              children: [
                Container(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                      children: colors.map((Color color) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, color);
                          },
                          child: CircleAvatar(backgroundColor: color),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              // children: colors.map((Color color) {
              //   return SimpleDialogOption(
              //     onPressed: () {
              //       Navigator.pop(context, color);
              //     },
              //     child: CircleAvatar(backgroundColor: color),
              //   );
              // }).toList(),
            );
          },
        );

        if (selectedColor != null) {
          // Use the selected color
          schedule.color = selectedColor.value.toString();
          print('Selected color: ${selectedColor.value.toString()}');
          schedules.updateOrCreateSchedule(schedule);
        }
      },
      icon: Icon(Icons.color_lens),
      color: schedule.colorValue,
    );
  }
}
