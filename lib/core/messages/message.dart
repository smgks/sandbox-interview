import 'package:flutter_sandbox/core/messages/candidate.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/core/messages/status.dart';

class MessageType {
   static String get offer => 'offer';
   static String get answer => 'answer';
   static String get candidate => 'candidate';
   static String get status => 'status';
}


class Message {
  final String type;
  final MsgContentBase content;

  Message({
    required this.type,
    required this.content
  });

  factory Message.offer(MsgContentBase data) => Message(
    type: MessageType.offer,
    content: data,
  );
  factory Message.answer(MsgContentBase data) => Message(
    type: MessageType.answer,
    content: data,
  );
  factory Message.candidate(MsgContentBase data) => Message(
      type: MessageType.candidate,
      content: data
  );
  factory Message.status(MsgContentBase data) => Message(
      type: MessageType.status,
      content: data
  );

  Map<String,dynamic> toJson() => {
    'type': type,
    'content': content.toJson(),
  };

  factory Message.fromJson(Map<String, dynamic> data) {
    var type = data['type'];
    MsgContentBase? content;
    switch (type) {
      case 'offer': {
        content = Offer.fromJson(data['content']);
      }
      break;
      case 'answer': {
        content = Offer.fromJson(data['content']);
      }
      break;
      case 'candidate': {
        content = Candidate.fromJson(data['content']);
      }
      break;
      case 'status': {
        content = Status.fromJson(data['content']);
      }
      break;
    }
    return Message(
      type: type,
      content: content!
  );
  }
}

abstract class MsgContentBase {
  Map<String, dynamic> toJson();

}