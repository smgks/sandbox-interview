import 'dart:async';
import 'dart:convert';


import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:injectable/injectable.dart';

/// Manage messages
@injectable
class WsSource {
  WsSource(this._connectionWS);

  StreamController<Message> _messageController = StreamController();
  late StreamSubscription _subscription;
  /// All messages from remote
  Stream<Message> get messages => _messageController.stream;
  final ConnectionWS _connectionWS;

  /// Initialize socket
  void init() {
    _connectionWS.connect();
    _subscription = _connectionWS.messages.listen(_handleMessage);
  }

  /// Handle messages and sends it to _messageController
  void _handleMessage(event) {
    var messageRaw = json.decode(event as String);
    var message = Message.fromJson(messageRaw);
    if (message.type != MessageType.status){
      _messageController.sink.add(message);
      print(event);
    }
  }

  /// Send message to ws
  void send(Message message){
    _connectionWS.send(json.encode(message.toJson()));
  }

  /// Close connection
  void close() {
    _messageController.close();
    _subscription.cancel();
  }
}