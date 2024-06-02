import 'package:ark_jots/modules/settings/settings_about_tab.dart';
import 'package:ark_jots/modules/settings/settings_app_tab.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:ark_jots/widgets/layouts/bottom_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  late final _tabCtrl = TabController(length: 2, vsync: this);
  final _scrollCtrl = ScrollController();

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
    // Not needed since Settings will be a single tab for now
    final children = [
      SettingsAppTab(_scrollCtrl),
      // const Text('Appearance'),
      // const Text('Notifications'),
      SettingsAboutTab(_scrollCtrl)
      // const Text('About'),
    ];

    return PageScaffold(
      bottomBar: BottomNavBar(
        current: _tabCtrl.index,
        onSame: (_) => _scrollCtrl.scrollToTop(),
        onChanged: (i) => _tabCtrl.index = i,
        items: const {
          'General': Ionicons.color_palette_outline,
          // 'Content': Ionicons.tv_outline,
          // 'Notifications': Ionicons.notifications_outline,
          'Información': Ionicons.information_outline,
        },
      ),
      // topBar: TopBar(
      //   title: 'Opciones',
      //   canPop: false,
      // ),
      // child: SettingsAppTab(scrollCtrl)
      child: TabBarView(controller: _tabCtrl, children: children),
    );
  }
}
