import 'package:flutter_sandbox/feature/call_page/domain/entities/candidate.dart';
import 'package:flutter_sandbox/feature/call_page/domain/entities/offer.dart';

class MessageType {
  static const String offer = 'offer';
  static const String answer = 'answer';
  static const String candidate = 'candidate';
}

class Message {
  final String type;
  final MsgContentBase content;

  Message({
    required this.type,
    required this.content
  });

  factory Message.offer(Offer data) => Message(
    type: MessageType.offer,
    content: data,
  );

  factory Message.answer(Offer data) => Message(
    type: MessageType.answer,
    content: data,
  );
  factory Message.candidate(Candidate data) => Message(
      type: MessageType.candidate,
      content: data
  );
}

abstract class MsgContentBase {}