part of 'contacts_bloc.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {
  final Set<User> users;
  ContactsInitial({required this.users});

  factory ContactsInitial.empty() => ContactsInitial(users: {});

  ContactsInitial copyWith(Set<User>? users) {
    return ContactsInitial(users: users ?? this.users);
  }
}

class ContactsErrorState extends ContactsState {}

class OfferReceivedState extends ContactsState {
  final Offer offer;
  final User from;

  OfferReceivedState(this.offer, this.from);
}

class LogOutState extends ContactsState {}
