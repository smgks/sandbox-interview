import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('user_cache');
  configureDependencies();
  test('ws_connection messaging',() async {
    WebSocketChannel? _socket = WebSocketChannel.connect(
        Uri.parse(getIt<String>(instanceName: 'baseUrl'))
    );

    _socket.stream.listen((data){
      print("received : ${data as String}");
    });
    ConnectionWS ws = ConnectionWS();
    ws.connect();
    await Future.delayed(Duration(seconds: 30));
    await ws.close();
    await _socket.sink.close();
  });

  // test('ws_connection users',() async {
  //
  //   ConnectionWS ws0 = ConnectionWS();
  //   ws0.connect();
  //
  //   ConnectionWS ws1 = ConnectionWS();
  //   ws1.connect();
  //   await Future.delayed(Duration(seconds: 10));
  //   assert (ws0.users.keys.length != 0);
  //   await ws1.close();
  //   await Future.delayed(Duration(seconds: 20));
  //   assert (ws0.users.keys.length == 0);
  //   await ws0.close();
  // });

  test('ws_connection stream',() async {
    ConnectionWS ws0 = ConnectionWS();
    ws0.connect();
    ws0.messages.listen((event) {
      print('event: $event');
    });

    ConnectionWS ws1 = ConnectionWS();
    ws1.connect();
    await Future.delayed(Duration(seconds: 16));
    await ws1.close();
    await ws0.close();
  });
}