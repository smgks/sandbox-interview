import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/login_page/domain/repositories/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('user_cache')
    ..delete('user_cache');
  configureDependencies();

  test('Login repository test', () async {
    final repo = getIt<IRepository>();
    var registered = repo.isUserRegistered();

    assert(registered == false);
    repo.saveUser(User.fromString('testtest'));

    registered = repo.isUserRegistered();
    assert(registered == true);
  });
}
