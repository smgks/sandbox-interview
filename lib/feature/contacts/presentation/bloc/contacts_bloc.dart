import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';
import 'package:flutter_sandbox/feature/contacts/domain/repository/repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

@injectable
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final IRepository _repository;
  StreamSubscription? _streamSubscription;

  ContactsBloc(this._repository) : super(ContactsInitial.empty()){
    _streamSubscription = _repository.userUpdates.listen((event) {
      add(_UsersChangedEvent(event));
    });
  }
  @override
  Future<void> close() async {
    _streamSubscription!.cancel();
    super.close();
  }

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    if (event is InitiateConnectionEvent) {
      // TODO : get from local ds
      _repository.initStatus(User('test','test'));
    } else if (event is DropConnectionEvent) {
      _repository.cancel();
    } else if (event is _UsersChangedEvent) {
      yield ContactsInitial(
        users: event.users
      );
    }
  }
}
