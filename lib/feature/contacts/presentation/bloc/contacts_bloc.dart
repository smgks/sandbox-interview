import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/contacts/domain/repositories/repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

@injectable
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final IRepository _repository;
  late StreamSubscription _streamSubscription;

  ContactsBloc(this._repository) : super(ContactsInitial.empty()) {
    add(InitiateConnectionEvent());
    _streamSubscription = _repository.userUpdates.listen((event) {
      add(_UsersChangedEvent(event));
    });
  }
  @override
  Future<void> close() async {
    await _repository.cancel();
    await _streamSubscription.cancel();
    super.close();
  }

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    if (event is InitiateConnectionEvent) {
      _repository.initStatus((Message message) {
        add(OfferReceivedEvent(message.content as Offer, message.from!));
      });
    } else if (event is DropConnectionEvent) {
      await close();
    } else if (event is OfferReceivedEvent) {
      yield OfferReceivedState(event.offer, event.from);
    } else if (event is _UsersChangedEvent) {
      yield ContactsInitial(users: event.users);
    } else if (event is LogOutEvent) {
      await _repository.cancel();
      await _repository.logout();
      await close();
      yield LogOutState();
    }
  }
}
