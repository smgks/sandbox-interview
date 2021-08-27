part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent {}
class InitiateConnectionEvent extends ContactsEvent {}
class DropConnectionEvent extends ContactsEvent {}
class _UsersChangedEvent extends ContactsEvent {
  final Set<User> users;

  _UsersChangedEvent(this.users);
}