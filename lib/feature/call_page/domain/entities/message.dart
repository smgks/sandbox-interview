class MessageType {
  static const String offer = 'offer';
  static const String answer = 'answer';
  static const String candidate = 'candidate';
}

class Message {
  final String type;
  final dynamic content;

  Message({
    required this.type,
    required this.content
  });

  Map<String,dynamic> toJson() => {
    'type': type,
    'content': content,
  };

  factory Message.fromJson(Map<String, dynamic> data) => Message(
      type: data['type'],
      content: data['content']
  );
  factory Message.offer(Map<String, dynamic> data) => Message(
      type: MessageType.offer,
      content: data
  );
  factory Message.answer(Map<String, dynamic> data) => Message(
      type: MessageType.answer,
      content: data
  );
  factory Message.candidate(Map<String, dynamic> data) => Message(
      type: MessageType.candidate,
      content: data
  );
}