import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompilerView extends StatelessWidget {
  const CompilerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabScaffold(
      topBar: TopBar(
        title: 'Quick Voice Task',
        canPop: false,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Press the button and say your task"),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your task',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
