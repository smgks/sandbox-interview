part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class CheckRegistered extends LoginEvent{

}

class ValidateUserName extends LoginEvent {
  final String username;

  ValidateUserName(this.username);
}

class LoginNew extends LoginEvent {
  final String user;

  LoginNew(this.user);
}