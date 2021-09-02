import 'dart:convert';

import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/contacts/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('user_cache');
  configureDependencies();

  test('contacts - status is alive', () async {
    var repo0 = getIt<IRepository>();
    repo0.initStatus((_) {});
    var messages = 0;

    WebSocketChannel? _socket = WebSocketChannel.connect(
        Uri.parse(getIt<String>(instanceName: 'baseUrl')));

    _socket.stream.listen((data) {
      var mapData = json.decode(data);
      if (mapData['type'] == 'status') {
        messages++;
      }
    });

    await Future.delayed(Duration(seconds: 15));
    assert(messages > 0);
  });
}
