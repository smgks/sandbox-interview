part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginIdle extends LoginState {
  const LoginIdle();
}

class LoginIn extends LoginState {
  final User user;

  const LoginIn(this.user);
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);
}
