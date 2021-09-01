import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/login_page/data/data_sources/data_source.dart';
import 'package:flutter_sandbox/feature/login_page/domain/repositories/repository.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: IRepository)
class Repository extends IRepository{
  final LocalDataSource _dataSource;

  Repository(this._dataSource);

  /// Get current user
  @override
  User receiveCached() {
    return _dataSource.receiveCached()!;
  }

  /// Save user to hive
  @override
  void saveUser(User user) {
    _dataSource.saveUser(user);
  }

  /// Returns true if user registered
  @override
  bool isUserRegistered() {
    return _dataSource.receiveCached() != null;
  }

}