import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';

abstract class IRepository{
  void initStatus();

  Stream<Set<User>> get userUpdates;

  void cancel();

  User getLocalUser();
}