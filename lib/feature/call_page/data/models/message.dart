import 'package:flutter_sandbox/feature/call_page/domain/entities/message.dart';

import 'candidate.dart';
import 'offer.dart';

class MessageType {
  static const String offer = 'offer';
  static const String answer = 'answer';
  static const String candidate = 'candidate';
}

class MessageModel extends Message {
  MessageModel({
    required String type,
    required MsgContentBase content
  }): content = content, super(type: type, content: content);
  MsgContentBase content;

  Map<String,dynamic> toJson() => {
    'type': type,
    'content': content.toJson(),
  };

  factory MessageModel.fromJson(Map<String, dynamic> data) => MessageModel(
      type: data['type'],
      content: data['content']
  );

  factory MessageModel.offer(Map<String, dynamic> data) => MessageModel(
    type: MessageType.offer,
    content: OfferModel.fromJson(data),
  );

  factory MessageModel.answer(Map<String, dynamic> data) => MessageModel(
    type: MessageType.answer,
    content: OfferModel.fromJson(data),
  );
  factory MessageModel.candidate(Map<String, dynamic> data) => MessageModel(
      type: MessageType.candidate,
      content: CandidateModel.fromJson(data)
  );

  factory MessageModel.fromDomain(Message parent) => MessageModel(
    content: parent.content,
    type: parent.type
  );
}

extension MsgContentBaseModel on MsgContentBase{
  Map<String,dynamic> toJson() => {};
}