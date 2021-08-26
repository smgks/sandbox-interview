import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@singleton
class WsServer {
  WsServer(@Named('baseUrl') this.signalingServerUrl);
  StreamController<Set<String>> _streamController = StreamController<Set<String>>();
  Stream<Set<String>> get stream => _streamController.stream.asBroadcastStream();

  Map<String,DateTime> users = {};


  WebSocketChannel? signalingWS;
  final String signalingServerUrl;

  void checkOnline() {
    users.keys.forEach((key) {
      if (users[key]!.difference(DateTime.now()).inSeconds > 15){
        users.remove(key);
      }
    });
  }

  void connect() {
    signalingWS = WebSocketChannel.connect(Uri.parse(signalingServerUrl));
    signalingWS!.stream.listen(_onMessage);
    Timer.periodic(Duration(seconds: 5), (timer) {
      signalingWS!.sink.add('temp');
      checkOnline();
    });
  }

  void _onMessage(dynamic data) {
    users[data as String] = DateTime.now();
    _streamController.sink.add(users.keys.toSet());
  }
}