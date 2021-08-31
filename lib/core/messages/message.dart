import 'package:flutter_sandbox/core/hive_models/user.dart';
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
  final User? from;
  final User? to;

  Message({
    required this.type,
    required this.content,
    this.from,
    this.to,
  });

  factory Message.offer(
      MsgContentBase data, {
        required User from,
        required User to,
      }) => Message(
    type: MessageType.offer,
    content: data,
    from: from,
    to: to
  );
  factory Message.answer(
      MsgContentBase data, {
        required User from,
        required User to,
      }) => Message(
      type: MessageType.answer,
      content: data,
      from: from,
      to: to
  );
  factory Message.candidate(
      MsgContentBase data, {
        required User from,
        required User to,
      }) => Message(
      type: MessageType.candidate,
      content: data,
      from: from,
      to: to
  );
  factory Message.status(
      MsgContentBase data
      ) => Message(
      type: MessageType.status,
      content: data,
  );

  Map<String,dynamic> toJson() => {
    'type': type,
    'content': content.toJson(),
    'from' : from == null ? null : from!.toJson(),
    'to' : to == null ? null : to!.toJson(),
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
      content: content!,
      from: data['from'] == null ? null : User.fromJson(data['from']),
      to: data['to'] == null ? null : User.fromJson(data['to']),
    );
  }
}

abstract class MsgContentBase {
  Map<String, dynamic> toJson();

}