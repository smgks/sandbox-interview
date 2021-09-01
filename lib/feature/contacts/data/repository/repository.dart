import 'dart:async';

import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/feature/contacts/data/data_sources/local_datasource.dart';
import 'package:flutter_sandbox/feature/contacts/data/data_sources/ws_source.dart';
import 'package:flutter_sandbox/feature/contacts/domain/repositories/repository.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: IRepository)
class Repository extends IRepository {
  final WsSource _wsSource;
  final LocalUserDataSource _localDataSource;
  late StreamSubscription _controller;

  Repository(
      this._wsSource,
      this._localDataSource,
    );

  Stream<Set<User>> get userUpdates => _wsSource.userUpdates;

  @override
  void initStatus(void Function(Message) onOffer) {
    _wsSource.listenUsers(getLocalUser());
    _controller = _wsSource.messages.listen((message){
      if(message.type == 'offer' && message.from != _localDataSource.receiveCached()){
        onOffer(message);
      }
    });
  }

  @override
  User getLocalUser() {
    var localUser =  _localDataSource.receiveCached();
    return User(
        username: localUser.username,
        idString: localUser.idString
    );
  }

  Future<void> cancel() async {
    await _controller.cancel();
    await _wsSource.close();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.removeCached();
  }
}