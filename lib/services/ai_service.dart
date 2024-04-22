import 'package:dart_openai/dart_openai.dart';

import '../env.dart';

class AiService {
  factory AiService() => _instance;

  static late AiService _instance;

  static bool _didInit = false;

  /// Should be called before use.
  static Future<void> init() async {
    if (_didInit) return;
    _didInit = true;

    OpenAI.apiKey = Env.apiKey;

    //WidgetsFlutterBinding.ensureInitialized();
    //_instance = Options._read();
  }

  var chatStream;

  static Future<String> getSubtasks(String message) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "I need you to give me a list of subtasks to divide this task. "
          "Give your answer as JSON.",
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

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
      stop: ['\n'],
    );
    return completion.data.choices[0].text;
  }
}
