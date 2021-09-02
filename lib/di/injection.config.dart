// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../core/ws_connection.dart' as _i3;
import '../feature/call_page/data/data_sources/local_datasource.dart' as _i5;
import '../feature/call_page/data/data_sources/ws_source.dart' as _i7;
import '../feature/call_page/data/repositories/repository.dart' as _i10;
import '../feature/call_page/domain/repositories/repository.dart' as _i9;
import '../feature/call_page/domain/use_cases/initialize_media.dart' as _i16;
import '../feature/call_page/domain/use_cases/media_device.dart' as _i6;
import '../feature/call_page/presentation/bloc/call_bloc.dart' as _i18;
import '../feature/contacts/data/data_sources/local_datasource.dart' as _i4;
import '../feature/contacts/data/data_sources/ws_source.dart' as _i8;
import '../feature/contacts/data/repository/repository.dart' as _i12;
import '../feature/contacts/domain/repositories/repository.dart' as _i11;
import '../feature/contacts/presentation/bloc/contacts_bloc.dart' as _i19;
import '../feature/login_page/data/data_sources/data_source.dart' as _i15;
import '../feature/login_page/data/repositories/repository.dart' as _i14;
import '../feature/login_page/domain/repositories/repository.dart' as _i13;
import '../feature/login_page/presentation/bloc/login_page/login_bloc.dart'
    as _i17;
import 'module.dart' as _i20; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectionModule = _$InjectionModule();
  gh.factory<_i3.ConnectionWS>(() => _i3.ConnectionWS());
  gh.factory<_i4.LocalUserDataSource>(() => _i4.LocalUserDataSource());
  gh.factory<_i5.LocalUserDataSource>(() => _i5.LocalUserDataSource());
  gh.factory<_i6.MediaDevice>(() => _i6.MediaDevice());
  gh.factory<String>(() => injectionModule.signalingServerUrl,
      instanceName: 'baseUrl');
  gh.factory<_i7.WsSource>(() => _i7.WsSource(get<_i3.ConnectionWS>()));
  gh.factory<_i8.WsSource>(() => _i8.WsSource(get<_i3.ConnectionWS>()));
  gh.factory<_i9.IRepository>(() =>
      _i10.Repository(get<_i5.LocalUserDataSource>(), get<_i7.WsSource>()));
  gh.factory<_i11.IRepository>(() =>
      _i12.Repository(get<_i8.WsSource>(), get<_i4.LocalUserDataSource>()));
  gh.factory<_i13.IRepository>(
      () => _i14.Repository(get<_i15.LocalDataSource>()));
  gh.factory<_i16.InitializeMedia>(
      () => _i16.InitializeMedia(get<_i9.IRepository>()));
  gh.factory<_i17.LoginBloc>(() => _i17.LoginBloc(get<_i13.IRepository>()));
  gh.factory<_i18.CallBloc>(
      () => _i18.CallBloc(get<_i16.InitializeMedia>(), get<_i6.MediaDevice>()));
  gh.factory<_i19.ContactsBloc>(
      () => _i19.ContactsBloc(get<_i11.IRepository>()));
  gh.singleton<_i15.LocalDataSource>(_i15.LocalDataSource());
  return get;
}

class _$InjectionModule extends _i20.InjectionModule {}
