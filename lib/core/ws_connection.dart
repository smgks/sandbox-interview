import 'dart:async';

import 'package:flutter_sandbox/di/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@singleton
class ConnectionWS {
  WebSocketChannel? _socket;
  StreamController _controller = StreamController();
  Stream get messages => _controller.stream;

  void connect() {
    _socket = WebSocketChannel.connect(
        Uri.parse(getIt<String>(instanceName: 'baseUrl'))
    );
    _onConnect();
    _socket!.sink.done.then(_onDisconnect);
    _socket!.stream.listen(_onMessage);
  }

  Future<void> close() async {
    _socket!.sink.close();
  }

  void send(dynamic data) {
    _socket!.sink.add(data);
  }

  void _onMessage(dynamic data) {
  }

  
  void _onDisconnect(data) {
    print('closed');
  }

  void _onConnect() {

  }
}