import 'package:ark_jots/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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

    return Card(
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Resumen por IA ",
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Ionicons.color_wand_outline),
              ],
            ),
            const SizedBox(height: 10),
            Text(provider.summary ?? "Loading summary..."),
          ],
        ),
      ),
    );
  }
}
