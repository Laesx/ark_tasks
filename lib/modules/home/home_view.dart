import 'package:ark_jots/modules/home/home_provider.dart';
import 'package:ark_jots/modules/schedule/schedule_view.dart';
import 'package:ark_jots/modules/tasks/task_summary_card.dart';
import 'package:ark_jots/modules/tasks/tasks_today_card.dart';
import 'package:ark_jots/modules/user/user_view.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:ark_jots/widgets/layouts/bottom_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/modules/tasks/tasks_view.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.tab});

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
              // Here we can add some logic to scroll to the top of the list.
            }),
        child: TabBarView(controller: _tabCtrl, children: [
          HomeWidget(
            tabCtrl: _tabCtrl,
          ),
          TasksView(ScrollController()),
          ScheduleView(ScrollController()),
          // const Text("data"),
          //const SettingsView(),
          const UserView(),
        ]));
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.tabCtrl});

  final TabController tabCtrl;

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.paddingOf(context).top;
    return TabScaffold(
        topBar: const TopBar(
          canPop: false,
          title: "Inicio",
        ),
        child: Padding(
          padding: Consts.padding,
          child: ListView(children: [
            SizedBox(height: topOffset),
            const TaskSummaryCard(),
            //Text("Shortcuts", style: TextStyle(fontSize: 20)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ShortcutButton(tabCtrl: tabCtrl, index: 1),
              ShortcutButton(tabCtrl: tabCtrl, index: 2)
            ]),
            const SizedBox(height: 30),
            Card(
                child: Column(
              children: [
                const SizedBox(height: 10),
                const Text("Tareas Pendientes Próximamente",
                    style: TextStyle(fontSize: 20)),
                Container(height: 250, child: const TasksTodayCard()),
              ],
            ))
          ]),
        ));
  }
}

class ShortcutButton extends StatelessWidget {
  const ShortcutButton({super.key, required this.tabCtrl, required this.index});

  final TabController tabCtrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tabCtrl.animateTo(index),
      child: Container(
        width: 150,
        height: 100,
        child: Card(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 15),
                  Icon(HomeTab.values[index].iconData, size: 40),
                  const SizedBox(height: 5),
                  Text(
                    HomeTab.values[index].title,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const Positioned(
                  right: 10, top: 10, child: Icon(Icons.arrow_outward_outlined))
            ],
          ),
        ),
      ),
    );
  }
}
