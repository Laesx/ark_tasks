import 'dart:async';
import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';

import '../env.dart';
import 'package:flutter/material.dart';

class AiService extends ChangeNotifier {
  // Singleton Stuff to save AI requests.
  factory AiService() => _instance;
  static late AiService _instance;
  static bool _didInit = false;

  AiService._();

  /// Should be called before use.
  static Future<void> init() async {
    if (_didInit) return;
    _didInit = true;

    OpenAI.apiKey = Env.apiKey;

    // OpenAI.showLogs = true;
    // OpenAI.showResponsesLogs = true;
    // WidgetsFlutterBinding.ensureInitialized();
    _instance = AiService._();
  }

  //String? lastMessage;
  //Future<List<String>>? lastResult;

  // Map with all the previous results for caching.
  Map<String, dynamic> previousResults = {};

  // TODO: Probably a good idea to add some error handling here in case the request fails.
  static Future<List<String>> getSubtasks(String message,
      {bool refresh = false}) async {
    if (message.isEmpty) {
      return [];
    }
    if (AiService().previousResults.containsKey(message) && !refresh) {
      return AiService().previousResults[message]!;
    }

    var completion =
        await _makeRequest(message, SystemMessages.subtaskSuggestions);

    String jsonResponse =
        completion.choices.first.message.content?.first.text ?? "";
    Map valueMap = json.decode(jsonResponse);

    // This is now done somewhat more dynamically but still not perfect.
    // Might give issues in the future.
    List<String> subtasks = [];
    valueMap.forEach((key, value) {
      if (value is List) {
        subtasks = value.cast<String>();
      }
    });

    // Setting the last message and result for caching.
    AiService().previousResults.addEntries([MapEntry(message, subtasks)]);

    return subtasks;
  }

  // TODO: Test this Future
  static Future<String> getSummary(String message,
      {bool refresh = false}) async {
    return _makeRequest(message, SystemMessages.summary)
        .then((value) => value.choices.first.message.content?.first.text ?? "");
  }

  // TODO: Probably a good idea to add some error handling here in case the request fails.
  static Future<OpenAIChatCompletionModel> _makeRequest(String message,
      OpenAIChatCompletionChoiceMessageModel systemMessage) async {
    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          message,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // all messages to be sent.
    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    var completion = await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: requestMessages,
      responseFormat: {"type": "json_object"},
      maxTokens: 100,
      temperature: 0.2,
    );

    return completion;
  }
} // class AiService

// This are system messages that are used to communicate with the AI.
abstract class SystemMessages {
  static final subtaskSuggestions = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "I need you to give me a list of subtasks to divide this task. "
        "Give your answer as JSON.",
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  );

  static final summary = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "I need you to make a short summary about what the user has to do today"
        " from all these tasks. ",
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  );
}

// This is for testing
Future<void> main() async {
  AiService.init();
  var subtasks = await AiService.getSubtasks("Clean the house.");
  print("Response");
  print(subtasks);
}
