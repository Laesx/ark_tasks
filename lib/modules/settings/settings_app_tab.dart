import 'package:ark_jots/utils/options.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';

class SettingsAppTab extends StatelessWidget {
  const SettingsAppTab(this.scrollCtrl);

  final ScrollController scrollCtrl;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    const tilePadding = EdgeInsets.only(bottom: 10, left: 10, right: 10);
    final listPadding = MediaQuery.paddingOf(context);

    return ListView(
      controller: scrollCtrl,
      padding: EdgeInsets.only(
        top: listPadding.top + TopBar.height + 10,
        bottom: listPadding.bottom + 10,
      ),
      children: [
        ExpansionTile(
          title: const Text('Appearance'),
          initiallyExpanded: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: SegmentedButton(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.sync_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.wb_sunny_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.mode_night_outlined),
                  ),
                ],
                selected: {Options().themeMode},
                onSelectionChanged: (v) => Options().themeMode = v.first,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
