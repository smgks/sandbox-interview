import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/login_page/data/data_sources/data_source.dart';
import 'package:flutter_sandbox/feature/login_page/domain/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IRepository)
class Repository extends IRepository{
  final LocalDataSource _dataSource;

  Repository(this._dataSource);

  @override
  User receiveCached() {
    return _dataSource.receiveCached()!;
  }

  @override
  void saveUser(User user) {
    _dataSource.saveUser(user);
  }

  @override
  bool isUserRegistered() {
    return _dataSource.receiveCached() != null;
  }

}