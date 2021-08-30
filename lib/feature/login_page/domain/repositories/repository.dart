import 'package:flutter_sandbox/core/hive_models/user.dart';

abstract class IRepository {

  /// Returns the cached user
  User receiveCached();

  /// Saves user to hive
  void saveUser(User user);

  /// Check if [user] registered,
  /// return true if registered, else returns false
  bool isUserRegistered();
}