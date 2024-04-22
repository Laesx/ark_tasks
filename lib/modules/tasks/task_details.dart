import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatelessWidget {
  TaskDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final taskProvider = Provider.of<TaskProvider>(context);
    //final tasks = context.watch(tasksProvider);
    return _TaskDetailsBody();
  }
}

class _TaskDetailsBody extends StatelessWidget {
  const _TaskDetailsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    final task = taskProvider.selectedTask ??
        Task(title: '', createdAt: DateTime.now(), lastUpdated: DateTime.now());

    return Scaffold(
        appBar: TopBar(
          trailing: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () => null)
          ],
          canPop: false,
          title: task.title,
        ),
        body: Container(
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  initialValue: task.title,
                  onChanged: (value) => task.title = value,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  initialValue: task.description,
                  onChanged: (value) => task.description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                    onPressed: () => taskProvider.updateOrCreateTask(task),
                    child: const Text('Save'))
              ],
            ),
          ),
        ));
  }
}

class _TaskForm extends StatelessWidget {
  const _TaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(onPressed: () => null, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
