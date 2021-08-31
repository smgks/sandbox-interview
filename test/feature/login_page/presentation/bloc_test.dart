import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/bloc/login_page/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('user_cache')
  ..delete('user_cache');
  configureDependencies();

  test('LoginBloc login', () async {
    final bloc = getIt<LoginBloc>();
    await Future.delayed(Duration(seconds: 2));
    assert(bloc.state is LoginIdle);
    bloc.add(LoginNew('testtest'));
    await Future.delayed(Duration(seconds: 2));
    assert(bloc.state is LoginIn);
  });
}