import 'package:ark_jots/utils/ai_service.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskSummaryCard extends StatefulWidget {
  const TaskSummaryCard({super.key});

  @override
  State<TaskSummaryCard> createState() => _TaskSummaryCardState();
}

class _TaskSummaryCardState extends State<TaskSummaryCard> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiService>();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 30, bottom: 50),
      decoration: BoxDecoration(
          // TODO: Remove this color and use the theme color
          color: const Color.fromARGB(255, 52, 52, 52),
          borderRadius: Consts.borderRadiusMin,
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              offset: Offset(0, 7),
              blurRadius: 10,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(provider.summary ?? "Loading summary..."),
      ),
    );
  }
}
