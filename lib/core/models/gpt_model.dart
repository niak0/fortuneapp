class ChatMessage {
  final String role;
  final String content;

  ChatMessage({
    required this.role,
    required this.content,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class ChatPost {
  final String model;
  final List<ChatMessage> messages;

  ChatPost({
    required this.model,
    required this.messages,
  });

  factory ChatPost.fromJson(Map<String, dynamic> json) {
    return ChatPost(
      model: json['model'],
      messages: (json['messages'] as List).map((message) => ChatMessage.fromJson(message)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
