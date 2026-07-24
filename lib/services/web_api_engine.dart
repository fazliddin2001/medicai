import 'dart:async';
import 'package:dart_openai/dart_openai.dart';
import 'package:medicai/models/chat_message.dart';
import 'package:medicai/services/ai_engine_interface.dart';

class WebApiEngine implements AIEngine {
  final String gatewayUrl;
  final String apiKey;
  final String model;

  WebApiEngine({
    required this.gatewayUrl,
    required this.apiKey,
    this.model = 'gpt-4o-mini',
  });

  @override
  Future<void> initialize() async {
    OpenAI.baseUrl = gatewayUrl;
    OpenAI.apiKey = apiKey;
  }

  @override
  Future<void> dispose() async {
    // No specific dispose needed for dart_openai
  }

  List<OpenAIChatCompletionChoiceMessageModel> _convertHistory(List<ChatMessage> history) {
    final messages = <OpenAIChatCompletionChoiceMessageModel>[
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [OpenAIChatCompletionChoiceMessageContentItemModel.text('You are a helpful and reliable AI medical assistant.')],
      )
    ];

    for (var msg in history) {
      final role = msg.role == MessageRole.user 
          ? OpenAIChatMessageRole.user 
          : OpenAIChatMessageRole.assistant;
      messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: role,
          content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(msg.text)],
        )
      );
    }
    return messages;
  }

  @override
  Future<String> sendMessage(String message, List<ChatMessage> history, {List<String>? attachmentPaths}) async {
    // Note: To support attachments in WebApiEngine (OpenAI API), we'd need to upload them or convert to base64.
    // For now, we'll just pass the text message.
    final messages = _convertHistory(history);
    messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(message)],
      )
    );

    final chatCompletion = await OpenAI.instance.chat.create(
      model: model,
      messages: messages,
    );

    return chatCompletion.choices.first.message.content?.first.text ?? '';
  }

  @override
  Stream<String> sendMessageStream(String message, List<ChatMessage> history, {List<String>? attachmentPaths}) {
    final controller = StreamController<String>();
    
    final messages = _convertHistory(history);
    messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(message)],
      )
    );

    final chatStream = OpenAI.instance.chat.createStream(
      model: model,
      messages: messages,
    );

    chatStream.listen(
      (streamEvent) {
        final content = streamEvent.choices.first.delta.content;
        if (content != null && content.isNotEmpty) {
          controller.add(content.first?.text ?? '');
        }
      },
      onDone: () => controller.close(),
      onError: (e) => controller.addError(e),
    );

    return controller.stream;
  }
}
