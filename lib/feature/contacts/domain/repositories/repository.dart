import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';

abstract class IRepository {
  void initStatus(void Function(Message) onOffer);

  Stream<Set<User>> get userUpdates;

  User getLocalUser();

  Future<void> cancel();

  Future<void> logout();
}
