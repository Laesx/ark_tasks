import 'package:ark_jots/modules/settings/theme_preview.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/utils/options.dart';
import 'package:ark_jots/widgets/fields/stateful_tiles.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ark_jots/services/local_notification_service.dart';

class SettingsAppTab extends StatelessWidget {
  const SettingsAppTab(this.scrollCtrl, {super.key});

  final ScrollController scrollCtrl;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    const tilePadding = EdgeInsets.only(bottom: 10, left: 10, right: 10);
    final listPadding = MediaQuery.paddingOf(context);

    final taskProvider = context.watch<TaskProvider>();

    return ListView(
      controller: scrollCtrl,
      padding: EdgeInsets.only(
        top: listPadding.top + TopBar.height + 10,
        bottom: listPadding.bottom + 10,
      ),
      children: [
        ExpansionTile(
          title: const Text('Apariencia'),
          initiallyExpanded: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ThemeModeSelection(),
            const ThemePreview(),
            StatefulSwitchListTile(
              title: const Text('Negro/Blanco Puro'),
              value: Options().pureWhiteOrBlackTheme,
              onChanged: (v) => Options().pureWhiteOrBlackTheme = v,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'OpenAI API Key',
            hintText: 'Api key',
            helperText: 'Your own API key to use more advanced options.',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () => TaskProvider.deleteTasksBox(),
            child: const Text('Delete Tasks Box')),
        ElevatedButton(
            onPressed: () => taskProvider.fillBoxWithDemoTasks(),
            child: const Text('Fill Box with Demo Tasks')),
        ElevatedButton(
            onPressed: () => LocalNotificationService()
                .showNotificationAndroid("Title", "Value"),
            child: const Text('Test Notification')),
        ElevatedButton(
            onPressed: () => LocalNotificationService().showTimedNotification(),
            child: const Text('Test Scheduled Notification'))
      ],
    );
  }
}

class _ThemeModeSelection extends StatefulWidget {
  const _ThemeModeSelection();

  @override
  State<_ThemeModeSelection> createState() => __ThemeModeSelectionState();
}

class __ThemeModeSelectionState extends State<_ThemeModeSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: SegmentedButton(
        segments: const [
          ButtonSegment(
            value: ThemeMode.system,
            label: Text('Sistema'),
            icon: Icon(Icons.sync_outlined),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            label: Text('Luz'),
            icon: Icon(Icons.wb_sunny_outlined),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            label: Text('Oscuridad'),
            icon: Icon(Icons.mode_night_outlined),
          ),
        ],
        selected: {Options().themeMode},
        onSelectionChanged: (v) => setState(
          () => Options().themeMode = v.first,
        ),
      ),
    );
  }
}
