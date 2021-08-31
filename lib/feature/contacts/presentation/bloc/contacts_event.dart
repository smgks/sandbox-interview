part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent {}
class InitiateConnectionEvent extends ContactsEvent {}
class DropConnectionEvent extends ContactsEvent {}
class LogOutEvent extends ContactsEvent {}
class OfferReceivedEvent extends ContactsEvent {
  final Offer offer;
  final User from;

  OfferReceivedEvent(this.offer,this.from);
}
class _UsersChangedEvent extends ContactsEvent {
  final Set<User> users;

  _UsersChangedEvent(this.users);
}