import 'package:flutter_sandbox/feature/contacts/data/data_sources/ws_source.dart';
import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';
import 'package:flutter_sandbox/feature/contacts/domain/repository/repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IRepository)
class Repository extends IRepository {
  final WsSource _source;

  Repository(this._source);

  Stream<Set<User>> get userUpdates => _source.userUpdates;

  @override
  void initStatus(User owner) {
    _source.listenUsers(owner);
  }

  void cancel() {
    _source.stopListening();
  }
}