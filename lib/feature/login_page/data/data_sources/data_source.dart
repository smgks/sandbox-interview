import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Used to fetch data from hive
@singleton
class LocalDataSource {
  var box = Hive.box('user_cache');
  var key = 'user_cache';
  User? receiveCached() {
    return box.get(key) as User?;
  }

  void saveUser(User user) {
    box.put(key, user);
  }
}