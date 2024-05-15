import 'package:ark_jots/modules/home/home_provider.dart';
import 'package:ark_jots/modules/schedule/schedule_view.dart';
import 'package:ark_jots/modules/settings/settings_view.dart';
import 'package:ark_jots/modules/tasks/task_summary_card.dart';
import 'package:ark_jots/modules/tasks/tasks_today_card.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:ark_jots/widgets/layouts/bottom_bar.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/modules/tasks/tasks_view.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          //const Center(child: Text('Home')),
          //const Center(child: Text('Home')),
          HomeSomething(
            tabCtrl: _tabCtrl,
          ),
          TasksView(ScrollController()),
          ScheduleView(ScrollController()),
          const SettingsView(),
        ]));
  }
}

class HomeSomething extends StatelessWidget {
  const HomeSomething({super.key, required this.tabCtrl});

  final TabController tabCtrl;

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.paddingOf(context).top;
    return TabScaffold(
        topBar: TopBar(
          canPop: false,
          title: "Inicio",
        ),
        child: Padding(
          padding: Consts.padding,
          child: ListView(children: [
            SizedBox(height: topOffset),
            Container(
              child: TaskSummaryCard(),
            ),
            //Text("Shortcuts", style: TextStyle(fontSize: 20)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ShortcutButton(tabCtrl: tabCtrl, index: 1),
              ShortcutButton(tabCtrl: tabCtrl, index: 2)
            ]),
            SizedBox(height: 30),
            Card(
                child: Column(
              children: [
                SizedBox(height: 10),
                Text("Tareas Pendientes Próximas",
                    style: TextStyle(fontSize: 20)),
                Container(height: 250, child: TasksTodayCard()),
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
                  SizedBox(height: 15),
                  Icon(HomeTab.values[index].iconData,
                      size: 40, color: Colors.white),
                  SizedBox(height: 5),
                  Text(
                    HomeTab.values[index].title,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Positioned(
                  right: 10,
                  top: 10,
                  child:
                      Icon(Icons.arrow_outward_outlined, color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
