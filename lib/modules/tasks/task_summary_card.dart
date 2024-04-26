import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/modules/tasks/tasks.dart';
import 'package:ark_jots/utils/ai_service.dart';
import 'package:ark_jots/utils/consts.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({super.key});

  Future<Stream<OpenAIStreamChatCompletionModel>> _getSummary() {
    return AiService.getSummaryStream(
        "Make up an example summary of whatever.");
  }

  @override
  Widget build(BuildContext context) {
    String summary = "";

    void _updateSummary(String? xd) {
      summary += xd ?? "";
      //print(summary);
    }

    return Container(
      width: double.infinity,
      height: 400,
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
      child: FutureBuilder<Stream<OpenAIStreamChatCompletionModel>>(
        future: _getSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: snapshot.data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(summary);
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    _updateSummary(snapshot
                        .data!.choices.first.delta.content!.first!.text);
                    //_printSummary(snapshot.data.toString());
                    return Text(summary ?? "Error loading summary 1 ");
                  } else if (snapshot.hasError) {
                    return Text("Error loading summary 2");
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                });
            //_updateSummary(snapshot);
            return Text(summary ?? "Error loading summary 1 ");
          } else if (snapshot.hasError) {
            return Text("Error loading summary 2");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
