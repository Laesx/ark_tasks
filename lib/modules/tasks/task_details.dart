import 'dart:math';

import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ark_jots/utils/tools.dart';

import '../../utils/ai_service.dart';

// ignore: must_be_immutable
class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({Key? key}) : super(key: key);

  bool showAllSubtasks = false;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Controller for the subtasks so I can empty it after one is created
    final TextEditingController textController = TextEditingController();

    final taskProvider = context.watch<TaskProvider>();

    final task = taskProvider.selectedTask!;

    // This is for the submenu to appear on the center of the screen
    final screenSize = MediaQuery.of(context).size;
    final xOffSet = screenSize.width * 0.25;

    return PopScope(
      onPopInvoked: (didPop) {
        print("Popped");
        if (didPop) {
          //taskProvider.selectedTask = null;
          if (task.title.isNotEmpty) {
            taskProvider.updateOrCreateTask(task);
            //taskProvider.deleteTask(task);
            //task.save();
          }
        }
      },
      child: Scaffold(
          appBar: TopBar(
            trailing: [
              IconButton(
                icon: const Icon(Icons.bolt_outlined),
                //onPressed: () => aiDialog(context, task)
                onPressed: () => null,
              )
            ],
            canPop: true,
            title: task.title,
          ),
          body: Form(
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

                // AI Subtask Suggestions
                ExpansionTile(
                    title: const Text('AI Subtask Suggestions'),
                    children: [
                      _SubtastkSuggestions(task: task),
                    ]),
                // Due Date Menu
                _DueDate(xOffSet: xOffSet, task: task),
                const SizedBox(
                  height: 20,
                ),
                // TODO: Reminders Menu
                _Reminders(xOffSet: xOffSet, task: task),
                TextFormField(
                  initialValue: task.description,
                  onChanged: (value) => task.description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                // TODO: Make so this button is not necessary
                ElevatedButton(
                    onPressed: () => taskProvider.updateOrCreateTask(task),
                    //onPressed: () => task.save(),
                    child: const Text('Save'))
              ],
            ),
          )),
    );
  }

  /* Future<String?> aiDialog(BuildContext context, Task task) async {
    // Returns a null Future
    if (task.title.isEmpty) return Future(() => null);

    Future<List<String>> response = AiService.getSubtasks(task.title);

    // TODO: THIS NEEDS FIXING ONLY FOR TESTING!!!!
    List<String> subtasks = await response;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Wrap(
                children: subtasks
                    .asMap()
                    .map((index, subtask) =>
                        MapEntry(index, _MyButton(id: index, text: subtask)))
                    .values
                    .toList(),
              ),
              const Text('This is a typical dialog.'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  } */
}

class _Reminders extends StatefulWidget {
  const _Reminders({
    super.key,
    required this.xOffSet,
    required this.task,
  });

  final double xOffSet;
  final Task task;

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
            leadingIcon: const Icon(Icons.calendar_today),
            child: Text('Tomorrow (${Tools.getWeekday(Tools.getTomorrow())})'),
            onPressed: () {
              widget.task.dueDate = Tools.getTomorrow();
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.edit_calendar_outlined),
            child: const Text("Choose a date"),
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
              //print(task.dueDate);
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
          Text('Reminder ${Tools.formatDateTime(widget.task.dueDate)}'),
        ],
      ),
    );
  }
}

class _DueDate extends StatefulWidget {
  const _DueDate({
    super.key,
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
            child: Text('Today (${Tools.getWeekday(DateTime.now())})'),
            onPressed: () {
              widget.task.dueDate = DateTime.now();
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.calendar_today),
            child: Text('Tomorrow (${Tools.getWeekday(Tools.getTomorrow())})'),
            onPressed: () {
              widget.task.dueDate = Tools.getTomorrow();
              setState(() {});
            }),
        MenuItemButton(
            leadingIcon: const Icon(Icons.edit_calendar_outlined),
            child: const Text("Choose a date"),
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
          Text('Due date ${Tools.formatDateTime(widget.task.dueDate)}'),
        ],
      ),
    );
  }
}

class _SubtasksSection extends StatefulWidget {
  const _SubtasksSection({
    super.key,
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
                  hintText: 'Add subtask',
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
            child: const Text('Show more'),
            onPressed: () {
              widget.widget.showAllSubtasks = true;
              setState(() {});
            },
          ),
        if (widget.task.subtasks.length > 3 && widget.widget.showAllSubtasks)
          TextButton(
            child: const Text('Show less'),
            onPressed: () {
              widget.widget.showAllSubtasks = false;
              setState(() {});
            },
          ),
      ],
    );
  }
}

class _SubtastkSuggestions extends StatelessWidget {
  const _SubtastkSuggestions({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    List<String> subtasks = [];

    return Scrollable(
      viewportBuilder: (context, offset) {
        return FutureBuilder<List<String>>(
          future: AiService.getSubtasks(task.title),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              subtasks = snapshot.data ?? [];
              return Wrap(
                children: subtasks
                    .asMap()
                    .map((index, subtask) =>
                        MapEntry(index, _MyButton(id: index, text: subtask)))
                    .values
                    .toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}

class _MyButton extends StatefulWidget {
  _MyButton({Key? key, required this.text, required this.id}) : super(key: key);

  final int id;
  final String text;

  @override
  State<_MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<_MyButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelected = !isSelected;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? const Icon(
                    Icons.check,
                    size: 15,
                  )
                : const Icon(
                    Icons.circle_outlined,
                    size: 15,
                  ),
            Text(widget.text),
          ],
        ),
      ),
    );
  }
}
