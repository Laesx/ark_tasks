import 'package:ark_jots/modules/tasks/task_card.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ark_jots/utils/tools.dart';

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
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
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
                    ))
          ],
          canPop: true,
          title: task.title,
        ),
        body: Form(
          child: Column(
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
}
