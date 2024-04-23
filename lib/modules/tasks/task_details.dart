import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ark_jots/utils/tools.dart';

import 'dart:async';

import '../../services/ai_service.dart';

class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({Key? key}) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    final task = taskProvider.selectedTask ??
        Task(title: '', createdAt: DateTime.now(), lastUpdated: DateTime.now());

    final screenSize = MediaQuery.of(context).size;
    final xOffSet = screenSize.width * 0.25;

    return Scaffold(
        appBar: TopBar(
          trailing: [
            IconButton(
                icon: const Icon(Icons.bolt_outlined),
                onPressed: () => aiDialog(context, task))
          ],
          canPop: true,
          title: task.title,
        ),
        body: Form(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Row(children: [
                TaskCheckbox(task.isComplete),
                Flexible(
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    initialValue: task.title,
                    onChanged: (value) => task.title = value,
                  ),
                ),
              ]),
              // TODO: Add subtasks functionality
              const Text('Add subtask'),
              ExpansionTile(
                  title: const Text('AI Subtask Suggestions'),
                  children: [
                    SubtastkSuggestions(task: task),
                  ]),
              // Due Date Menu
              SubmenuButton(
                alignmentOffset: Offset(xOffSet, 0),
                menuChildren: [
                  MenuItemButton(
                      leadingIcon: Icon(Icons.calendar_today),
                      child: Text(
                          'Tomorrow (${Tools.getWeekday(Tools.getTomorrow())})'),
                      onPressed: () {
                        task.dueDate = Tools.getTomorrow();
                        setState(() {});
                      }),
                  MenuItemButton(
                      leadingIcon: Icon(Icons.edit_calendar_outlined),
                      child: Text("Choose a date"),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100))
                            .then((value) {
                          if (value != null) {
                            task.dueDate = value;
                            setState(() {});
                          }
                        });
                        //submenuButtonKey.currentState!.closeMenu();
                        //print(task.dueDate);
                      }),
                ],
                trailingIcon: task.dueDate != null
                    ? IconButton(
                        onPressed: () {
                          task.dueDate = null;
                          setState(() {});
                        },
                        icon: Icon(Icons.close))
                    : null,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_outlined),
                    SizedBox(width: 10),
                    Text('Due date ${Tools.formatDateTime(task.dueDate)}'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // TODO: Reminders Menu
              SubmenuButton(
                alignmentOffset: Offset(xOffSet, 0),
                menuChildren: [
                  MenuItemButton(
                      leadingIcon: Icon(Icons.calendar_today),
                      child: Text(
                          'Tomorrow (${Tools.getWeekday(Tools.getTomorrow())})'),
                      onPressed: () {
                        task.dueDate = Tools.getTomorrow();
                        setState(() {});
                      }),
                  MenuItemButton(
                      leadingIcon: Icon(Icons.edit_calendar_outlined),
                      child: Text("Choose a date"),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100))
                            .then((value) {
                          if (value != null) {
                            task.dueDate = value;
                            setState(() {});
                          }
                        });
                        //submenuButtonKey.currentState!.closeMenu();
                        //print(task.dueDate);
                      }),
                ],
                trailingIcon: task.dueDate != null
                    ? IconButton(
                        onPressed: () {
                          task.dueDate = null;
                          setState(() {});
                        },
                        icon: Icon(Icons.close))
                    : null,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_outlined),
                    SizedBox(width: 10),
                    Text('Due date ${Tools.formatDateTime(task.dueDate)}'),
                  ],
                ),
              ),
              TextFormField(
                initialValue: task.description,
                onChanged: (value) => task.description = value,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              // TODO: Make so this button is not necessary
              ElevatedButton(
                  onPressed: () => taskProvider.updateOrCreateTask(task),
                  child: const Text('Save'))
            ],
          ),
        ));
  }

  Future<String?> aiDialog(BuildContext context, Task task) async {
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
                    .map((subtask) => _MyButton(text: subtask))
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
  }
}

class SubtastkSuggestions extends StatelessWidget {
  SubtastkSuggestions({super.key, required this.task});

  final Task task;

  Future<List<String>> getSubtasks() async {
    return await AiService.getSubtasks(task.title);
  }

  @override
  Widget build(BuildContext context) {
    List<String> subtasks = [];

    return Scrollable(
      viewportBuilder: (context, offset) {
        return FutureBuilder<List<String>>(
          future: getSubtasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              subtasks = snapshot.data ?? [];
              return Wrap(
                children: subtasks
                    .map((subtask) => _MyButton(text: subtask))
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
  _MyButton({Key? key, required this.text}) : super(key: key);

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
