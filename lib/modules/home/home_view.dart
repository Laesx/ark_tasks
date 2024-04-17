import 'package:ark_jots/modules/home/home_provider.dart';
import 'package:ark_jots/widgets/layouts/bottom_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/modules/tasks/tasks_list_widget.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({this.tab});

  final HomeTab? tab;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late final _tabCtrl = TabController(
    length: HomeTab.values.length,
    vsync: this,
  );

  // This handles the initial tab selection.
  @override
  void initState() {
    super.initState();
    // Default to the first tab.
    _tabCtrl.index = 0;
    if (widget.tab != null) _tabCtrl.index = widget.tab!.index;
    _tabCtrl.addListener(() => setState(() {}));
  }

  // This handles changing the tab selection and it showing the one currently selected.
  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    if (widget.tab != null) _tabCtrl.index = widget.tab!.index;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        bottomBar: BottomNavBar(
            current: _tabCtrl.index,
            items: {
              for (final t in HomeTab.values) t.title: t.iconData,
            },
            onChanged: (i) => _tabCtrl.index = i,
            onSame: (i) {
              // TODO Does this need to be implemented?
            }),
        child: TabBarView(controller: _tabCtrl, children: [
          const Center(child: Text('Home')),
          const Center(child: Text('Home')),
          TasksListWidget(ScrollController()),
          const Center(child: Text('Something')),
          const Center(child: Text('Settings')),
        ]));
  }
}
