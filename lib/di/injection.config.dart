// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../core/ws_connection.dart' as _i5;
import '../feature/call_page/data/data_sources/ws_source.dart' as _i4;
import '../feature/call_page/presentation/manager/signaling.dart' as _i14;
import '../feature/contacts/data/data_sources/local_datasource.dart' as _i3;
import '../feature/contacts/data/data_sources/ws_source.dart' as _i6;
import '../feature/contacts/data/repository/repository.dart' as _i8;
import '../feature/contacts/domain/repositories/repository.dart' as _i7;
import '../feature/contacts/presentation/bloc/contacts_bloc.dart' as _i13;
import '../feature/login_page/data/data_sources/data_source.dart' as _i11;
import '../feature/login_page/data/repositories/repository.dart' as _i10;
import '../feature/login_page/domain/repositories/repository.dart' as _i9;
import '../feature/login_page/presentation/bloc/login_page/login_bloc.dart'
    as _i12;
import 'module.dart' as _i15; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectionModule = _$InjectionModule();
  gh.factory<_i3.LocalUserDataSource>(() => _i3.LocalUserDataSource());
  gh.factory<String>(() => injectionModule.signalingServerUrl,
      instanceName: 'baseUrl');
  gh.factory<_i4.WsSource>(() => _i4.WsSource(get<_i5.ConnectionWS>()));
  gh.factory<_i6.WsSource>(() => _i6.WsSource(get<_i5.ConnectionWS>()));
  gh.factory<_i7.IRepository>(() =>
      _i8.Repository(get<_i6.WsSource>(), get<_i3.LocalUserDataSource>()));
  gh.factory<_i9.IRepository>(
      () => _i10.Repository(get<_i11.LocalDataSource>()));
  gh.factory<_i12.LoginBloc>(() => _i12.LoginBloc(get<_i9.IRepository>()));
  gh.factory<_i13.ContactsBloc>(
      () => _i13.ContactsBloc(get<_i7.IRepository>()));
  gh.singleton<_i5.ConnectionWS>(_i5.ConnectionWS());
  gh.singleton<_i11.LocalDataSource>(_i11.LocalDataSource());
  gh.singleton<_i14.Signaling>(_i14.Signaling(get<_i5.ConnectionWS>()));
  return get;
}

class _$InjectionModule extends _i15.InjectionModule {}
