import 'package:ark_jots/modules/settings/settings_app_tab.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  late final _tabCtrl = TabController(length: 4, vsync: this);
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    //_scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = [
      SettingsAppTab(scrollCtrl),
      const Text('Appearance'),
      const Text('Notifications'),
      const Text('About'),
    ];

    return PageScaffold(
        child: TabBarView(controller: _tabCtrl, children: children));
  }
}
