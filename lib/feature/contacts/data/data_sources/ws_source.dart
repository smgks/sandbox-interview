import 'dart:async';
import 'dart:convert';

import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:flutter_sandbox/feature/contacts/data/models/user.dart';
import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

typedef UserUpdateEvent = void Function(User);

@injectable
class WsSource {
  WsSource(this._connectionWS);

  final ConnectionWS _connectionWS;
  Map<User,DateTime> users = {};
  Timer? _timer;
  StreamSubscription? _streamSubscription;
  StreamController<Set<User>> _controller = StreamController();
  Stream<Set<User>> get userUpdates => _controller.stream;


  void listenUsers(User owner) {
    assert(_streamSubscription == null);
    _streamSubscription = _connectionWS.messages.listen((event) {
      var message = json.decode(event as String);
      var user = UserModel.fromJson(message);
      if (users.containsKey(user)){
        _controller.add(users.keys.toSet());
      }
      users[UserModel.fromJson(message)] = DateTime.now();
      checkOnline();
    });
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkOnline();
      isAliveEvent(owner);
    });
  }

  void stopListening() {
    _streamSubscription!.cancel();
    _timer!.cancel();
  }

  void checkOnline() {
    users.keys.forEach((User key) {
      if (DateTime.now().millisecondsSinceEpoch - users[key]!.millisecondsSinceEpoch > 15000){
        users.remove(key);
      }
    });
  }

  void isAliveEvent(User owner) {
    _connectionWS.send('temp');
    print('temp');
  }
}