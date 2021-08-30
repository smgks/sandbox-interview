import 'dart:async';
import 'dart:convert';

import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/status.dart';
import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

typedef UserUpdateEvent = void Function(User);

@injectable
class WsSource {
  WsSource(this._connectionWS);

  final ConnectionWS _connectionWS;
  Map<User,DateTime> users = {};
  Timer? _timer;
  User? _owner;
  StreamSubscription? _streamSubscription;
  StreamController<Set<User>> _controller = StreamController();
  Stream<Set<User>> get userUpdates => _controller.stream;


  void listenUsers(User owner) {
    assert(_streamSubscription == null);
    _owner = owner;
    _connectionWS.connect();
    _streamSubscription = _connectionWS.messages.listen(handleMessage);
    _timer = Timer.periodic(Duration(seconds: 5), timerTick);
  }

  void timerTick(timer) {
    checkOnline();
    isAliveEvent(_owner!);
  }

  void handleMessage(event) {
    print(event);
    var messageRaw = json.decode(event as String);
    var message = Message.fromJson(messageRaw);
    if (message.type == MessageType.status){
      var userData = message.content as Status;
      var user = User(userData.user, userData.id);
      if (users.containsKey(user)) {
        _controller.add(users.keys.toSet());
      }
      users[user] = DateTime.now();
    }
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
    _connectionWS.send(
        json.encode(Message.status(
            Status(
              user: owner.name,
              id: owner.id
            )
        ).toJson())
    );
  }
}