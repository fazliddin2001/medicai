import 'package:medicai/models/chat_message.dart';

abstract class AIEngine {
  Future<void> initialize();
  Future<void> dispose();
  
  /// Sends a message and returns the full response.
  Future<String> sendMessage(String message, List<ChatMessage> history, {List<String>? attachmentPaths});
  
  /// Stream response for typing effect
  Stream<String> sendMessageStream(String message, List<ChatMessage> history, {List<String>? attachmentPaths});
}
