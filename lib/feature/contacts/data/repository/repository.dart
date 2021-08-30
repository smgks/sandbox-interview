import 'package:flutter_sandbox/feature/contacts/data/data_sources/local_datasource.dart';
import 'package:flutter_sandbox/feature/contacts/data/data_sources/ws_source.dart';
import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';
import 'package:flutter_sandbox/feature/contacts/domain/repositories/repository.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: IRepository)
class Repository extends IRepository {
  final WsSource _wsSource;
  final LocalUserDataSource _localDataSource;

  Repository(this._wsSource, this._localDataSource);

  Stream<Set<User>> get userUpdates => _wsSource.userUpdates;

  @override
  void initStatus() {
    _wsSource.listenUsers(getLocalUser());
  }

  @override
  User getLocalUser() {
    var localUser =  _localDataSource.receiveCached();
    return User(
        localUser.username,
        localUser.idString
    );
  }

  void cancel() {
    _wsSource.stopListening();
  }
}