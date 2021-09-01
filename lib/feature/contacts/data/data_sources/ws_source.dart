import 'dart:async';
import 'dart:convert';

import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/status.dart';
import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:injectable/injectable.dart';

typedef UserUpdateEvent = void Function(User);

@injectable
class WsSource {
  WsSource(this._connectionWS);

  final ConnectionWS _connectionWS;
  Map<User,DateTime> users = {};
  Timer? _timer;
  User? _owner;
  late StreamSubscription _streamSubscription;
  StreamController<Set<User>> _userController = StreamController();
  StreamController<Message> _messageController = StreamController();
  Stream<Set<User>> get userUpdates => _userController.stream;
  Stream<Message> get messages => _messageController.stream;

  void listenUsers(User owner) {
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
      var user = User(username: userData.user, idString: userData.id);
      if (user == _owner) {
        return;
      }
      users[user] = DateTime.now();
      _userController.sink.add(users.keys.toSet());
    } else {
      _messageController.sink.add(message);
    }
  }

  Future<void> close() async {
    await _userController.close();
    await _messageController.close();
    await _streamSubscription.cancel();
    _timer!.cancel();
  }

  void checkOnline() {
    List<User> toRemove = [];
    users.keys.forEach((User key) {
      if (DateTime.now().millisecondsSinceEpoch - users[key]!.millisecondsSinceEpoch > 15000){
        toRemove.add(key);
      }
    });
    toRemove.forEach((element) {
      users.remove(element);
    });
    _userController.sink.add(users.keys.toSet());
  }

  void isAliveEvent(User owner) {
    _connectionWS.send(
        json.encode(Message.status(
            Status(
              user: owner.username,
              id: owner.idString
            )
        ).toJson())
    );
  }
}