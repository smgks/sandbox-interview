import 'dart:async';

import 'package:flutter_sandbox/di/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

///
@injectable
class ConnectionWS {
  WebSocketChannel? _socket;
  StreamController _controller = StreamController();
  late StreamSubscription _subscription;
  Stream get messages => _controller.stream.asBroadcastStream();

  /// Connect to ws
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
    _subscription = _socket!.stream.listen(_onMessage);
  }

  /// Close ws connection
  Future<void> close() async {
    await _subscription.cancel();
    await _controller.close();
    await _socket!.sink.close();
  }

  /// Send data to remote ws
  void send(dynamic data) {
    connect();
    _socket!.sink.add(data);
  }

  void _onMessage(dynamic data) {
    _controller.sink.add(data);
  }

  
  void _onDisconnect(data) {
    connect();
  }

  void _onConnect() {
  }
}