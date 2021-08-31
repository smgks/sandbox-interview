import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/login_page/domain/repositories/repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._repository) : super(LoginInitial()) {
    add(CheckRegistered());
  }
  final IRepository _repository;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is CheckRegistered) {
      if (_repository.isUserRegistered()) {
        yield LoginIn(_repository.receiveCached());
      } else {
        yield LoginIdle();
      }
    }
    if (event is LoginNew) {
      var user = User.fromString(event.user);
      _repository.saveUser(user);
      yield LoginIn(user);
    }
  }
}
