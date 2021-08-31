import 'dart:async';

import 'package:flutter_sandbox/di/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@singleton
class ConnectionWS {
  WebSocketChannel? _socket;
  StreamController? _controller;
  Stream get messages => _controller!.stream;

  void connect() {
    if (_socket != null &&_socket!.closeCode == null) {
        return ;
    }
    _socket = WebSocketChannel.connect(
        Uri.parse(getIt<String>(instanceName: 'baseUrl'))
    );
    _controller = StreamController();
    _onConnect();
    _socket!.sink.done.then(_onDisconnect);
    _socket!.stream.listen(_onMessage);
  }

  Future<void> close() async {
    await _controller!.close();
    await _socket!.sink.close();
  }

  void send(dynamic data) {
    connect();
    _socket!.sink.add(data);
  }

  void _onMessage(dynamic data) {
    _controller!.sink.add(data);
  }

  
  void _onDisconnect(data) {
    connect();
    print('closed');
  }

  void _onConnect() {
    print('connected');
  }
}