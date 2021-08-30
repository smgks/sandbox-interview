import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocalUserDataSource {
  var box = Hive.box('user_chache');
  var key = 'user_chache';
  User receiveCached() {
    return box.get(key) as User;
  }
}