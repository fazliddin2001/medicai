enum MessageRole { user, ai, system }

class ChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final bool isGenerating;
  final List<String> attachmentPaths;

  ChatMessage({
    required this.text,
    required this.role,
    DateTime? timestamp,
    this.isGenerating = false,
    this.attachmentPaths = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessage copyWith({
    String? text,
    MessageRole? role,
    DateTime? timestamp,
    bool? isGenerating,
    List<String>? attachmentPaths,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isGenerating: isGenerating ?? this.isGenerating,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
    );
  }
}
