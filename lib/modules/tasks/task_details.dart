import 'dart:math';

import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/services/local_notification_service.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:async/async.dart';

import '../../services/ai_service.dart';

// ignore: must_be_immutable
class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({super.key});

  bool showAllSubtasks = false;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  var choicesMemoizer = AsyncMemoizer<List<String>>();

  void resetMemoizer() {
    choicesMemoizer = AsyncMemoizer<List<String>>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Controller for the subtasks so I can empty it after one is created
    final TextEditingController textController = TextEditingController();

    final taskProvider = context.watch<TaskProvider>();

    final task = taskProvider.selectedTask!;

    // This is for the submenu to appear on the center of the screen
    final screenSize = MediaQuery.of(context).size;
    final xOffSet = screenSize.width * 0.25;

    return Scaffold(
        appBar: const TopBar(
          canPop: true,
          title: "Detalles de la Tarea",
        ),
        body: Hero(
          tag: 'task-${task.key}',
          child: Material(
            type: MaterialType.transparency,
            child: Form(
              onPopInvoked: (didPop) {
                if (didPop) {
                  if (task.title.isNotEmpty) {
                    taskProvider.updateOrCreateTask(task);
                  }
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(5),
                children: [
                  //const SizedBox(height: 20),
                  Row(children: [
                    TaskCheckbox(task),
                    Flexible(
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        decoration: const InputDecoration(counterText: ''),
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 250,
                        //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        initialValue: task.title,
                        onChanged: (value) => task.title = value,
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
                  // Subtasks functionality
                  _SubtasksSection(
                      widget: widget, task: task, controller: textController),
                  _SubtaskPrompt(
                    task: task,
                    onUpdated: () => taskProvider.updateOrCreateTask(task),
                    choicesMemoizer: choicesMemoizer,
                  ),
                  ElevatedButton(
                    onPressed: resetMemoizer,
                    child: const Text('Refrescar Sugerencias por IA'),
                  ),
                  // Due Date Menu
                  _DueDate(xOffSet: xOffSet, task: task),
                  const SizedBox(
                    height: 20,
                  ),
                  // Reminders Menu - DONE
                  _Reminders(
                      xOffSet: xOffSet, task: task, taskProvider: taskProvider),
                  TextFormField(
                    initialValue: task.description,
                    onChanged: (value) => task.description = value,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  // Make so this button is not necessary - DONE
                  // ElevatedButton(
                  //     onPressed: () => taskProvider.updateOrCreateTask(task),
                  //     //onPressed: () => task.save(),
                  //     child: const Text('Save'))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Reminders extends StatefulWidget {
  const _Reminders({
    required this.xOffSet,
    required this.task,
    required this.taskProvider,
  });

  final double xOffSet;
  final Task task;
  final TaskProvider taskProvider;

  @override
  State<_Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<_Reminders> {
  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      alignmentOffset: Offset(widget.xOffSet, 0),
      menuChildren: [
        MenuItemButton(
            leadingIcon: const Icon(Icons.lock_clock),
            child: Text('Mañana (${Tools.getWeekday(Tools.getTomorrow())})'),
            onPressed: () {
              widget.task.reminder = Tools.getTomorrow();
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.notifications),
            child: const Text("Seleccionar día y hora"),
            onPressed: () {
              // This is to make sure the task is saved before setting the reminder
              // so it has a key
              if (widget.task.title.isNotEmpty) {
                widget.taskProvider.updateOrCreateTask(widget.task);
              }

              showDateTimePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100))
                  .then((value) {
                if (value != null) {
                  widget.task.reminder = value;
                  LocalNotificationService().scheduleNotification(
                      widget.task.key,
                      "Recordatorio de Tarea",
                      widget.task.title,
                      widget.task.reminder!);
                  setState(() {});
                }
              });
              //submenuButtonKey.currentState!.closeMenu();
              //print(task.dueDate);
            }),
      ],
      trailingIcon: widget.task.reminder != null
          ? IconButton(
              onPressed: () {
                widget.task.reminder = null;
                setState(() {});
              },
              icon: const Icon(Icons.close))
          : null,
      child: Row(
        children: [
          const Icon(Icons.notifications),
          const SizedBox(width: 10),
          Text('Recordatorio ${Tools.formatDateTime(widget.task.reminder)}'),
        ],
      ),
    );
  }
}

class _DueDate extends StatefulWidget {
  const _DueDate({
    required this.xOffSet,
    required this.task,
  });

  final double xOffSet;
  final Task task;

  @override
  State<_DueDate> createState() => _DueDateState();
}

class _DueDateState extends State<_DueDate> {
  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      alignmentOffset: Offset(widget.xOffSet, 0),
      menuChildren: [
        MenuItemButton(
            leadingIcon: const Icon(Icons.calendar_today),
            child: Text('Hoy (${Tools.getWeekday(DateTime.now())})'),
            onPressed: () {
              widget.task.dueDate = DateTime.now();
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.calendar_today),
            child: Text('Mañana (${Tools.getWeekday(Tools.getTomorrow())})'),
            onPressed: () {
              widget.task.dueDate = Tools.getTomorrow();
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
                  widget.task.dueDate = value;
                  setState(() {});
                }
              });
              //submenuButtonKey.currentState!.closeMenu();
            }),
      ],
      trailingIcon: widget.task.dueDate != null
          ? IconButton(
              onPressed: () {
                widget.task.dueDate = null;
                setState(() {});
              },
              icon: const Icon(Icons.close))
          : null,
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined),
          const SizedBox(width: 10),
          Text('Fecha límite ${Tools.formatDate(widget.task.dueDate)}'),
        ],
      ),
    );
  }
}

class _SubtasksSection extends StatefulWidget {
  const _SubtasksSection({
    required this.widget,
    required this.task,
    required TextEditingController controller,
  }) : _controller = controller;

  final TaskDetailScreen widget;
  final Task task;
  final TextEditingController _controller;

  @override
  State<_SubtasksSection> createState() => _SubtasksSectionState();
}

class _SubtasksSectionState extends State<_SubtasksSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.widget.showAllSubtasks
              ? widget.task.subtasks.length
              : min(3, widget.task.subtasks.length),
          itemBuilder: (context, index) {
            final subtask = widget.task.subtasks[index];
            return ListTile(
                // TODO: Make this a TextField to be able to edit it
                title: Text(subtask.title),
                leading: TaskCheckbox(widget.task, subtask: subtask),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      widget.task.subtasks.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
                shape: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ));
          },
        ),
        Row(
          children: [
            const Icon(Icons.add),
            Flexible(
              child: TextField(
                controller: widget._controller,
                decoration: const InputDecoration(
                  hintText: 'Añadir Subtarea',
                ),
                onSubmitted: (value) {
                  widget.task.subtasks.add(Subtask(title: value));
                  widget._controller.clear();
                  //setState(() {});
                },
              ),
            ),
          ],
        ),
        if (widget.task.subtasks.length > 3 && !widget.widget.showAllSubtasks)
          TextButton(
            child: const Text('Mostrar más'),
            onPressed: () {
              widget.widget.showAllSubtasks = true;
              setState(() {});
            },
          ),
        if (widget.task.subtasks.length > 3 && widget.widget.showAllSubtasks)
          TextButton(
            child: const Text('Mostrar menos'),
            onPressed: () {
              widget.widget.showAllSubtasks = false;
              setState(() {});
            },
          ),
      ],
    );
  }
}

class _SubtaskPrompt extends StatefulWidget {
  const _SubtaskPrompt(
      {required this.task,
      required this.onUpdated,
      required this.choicesMemoizer});
  final Task task;
  final void Function() onUpdated;
  final AsyncMemoizer<List<String>> choicesMemoizer;

  @override
  State<_SubtaskPrompt> createState() => _SubtaskPromptState();
}

class _SubtaskPromptState extends State<_SubtaskPrompt> {
  List<String> choicesValue = [];
  //final choicesMemoizer = AsyncMemoizer<List<String>>();

  // Maybe to make this easier I could add a field to subtask to know it's AI generated
  // Currently doesn't check if the subtask is already in the list before adding it
  void setChoicesValue(List<String> value) {
    // print(value);
    for (String subtask in value) {
      if (!widget.task.subtasks.any((element) => element.title == subtask)) {
        // print("Added");
        widget.task.subtasks.add(Subtask(title: subtask));
      }
    }
    for (String subtask in choicesValue) {
      if (!value.contains(subtask)) {
        // print("Removed");
        widget.task.subtasks.removeWhere((element) => element.title == subtask);
      }
    }

    setState(() => choicesValue = value);
    widget.onUpdated();
    //TaskProvider().updateOrCreateTask(widget.task);
  }

  Future<List<String>> getChoices() async {
    // return AiService.getSubtasks("Levantarme de la Cama");
    // print("Getting choices");
    return AiService.getSubtasks(widget.task.title);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        child: FutureBuilder<List<String>>(
            initialData: const [],
            future: widget.choicesMemoizer.runOnce(getChoices),
            builder: (context, snapshot) {
              return PromptedChoice<String>.multiple(
                confirmation: true,
                title: 'Subtareas sugeridas por IA',
                clearable: true,
                error: snapshot.hasError,
                errorBuilder: ChoiceListError.create(
                  message: snapshot.error.toString(),
                ),
                loading: snapshot.connectionState == ConnectionState.waiting,
                value: choicesValue,
                onChanged: setChoicesValue,
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (state, i) {
                  final choice = snapshot.data?.elementAt(i);
                  return CheckboxListTile(
                    value: state.selected(choice!),
                    onChanged: state.onSelected(choice),
                    title: Text(choice),
                  );
                },
                modalHeaderBuilder: ChoiceModal.createHeader(
                  title: const Text('Selecciona las Subtareas'),
                  automaticallyImplyLeading: false,
                  actionsBuilder: [
                    (state) {
                      return IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: state.clear,
                      );
                    },
                    ChoiceModal.createConfirmButton(),
                    ChoiceModal.createSpacer(width: 10),

                    // ChoiceModal.createSpacer(width: 25),
                  ],
                ),
                promptDelegate: ChoicePrompt.delegateBottomSheet(),
                anchorBuilder: ChoiceAnchor.create(valueTruncate: 1),
              );
            }),
      ),
    );
  }
}
