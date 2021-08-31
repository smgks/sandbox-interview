import 'dart:async';
import 'dart:convert';


import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:injectable/injectable.dart';

@injectable
class WsSource {
  WsSource(this._connectionWS);

  StreamController<Message> _messageController = StreamController();
  Stream<Message> get messages => _messageController.stream;
  final ConnectionWS _connectionWS;

  void init() {
    _connectionWS.connect();
  }

  void handleMessage(event) {
    var messageRaw = json.decode(event as String);
    var message = Message.fromJson(messageRaw);
    if (message.type != MessageType.status){
      _messageController.sink.add(message);
      print(event);
    }
  }

  void send(Message message){
    _connectionWS.send(json.encode(message.toJson()));
  }
  void close() {
    _messageController.close();
  }
}