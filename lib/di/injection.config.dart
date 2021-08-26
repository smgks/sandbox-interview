// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../feature/call_page/presentation/manager/signaling.dart' as _i4;
import '../feature/contacts/data/data_sources/ws_source.dart' as _i3;
import 'module.dart' as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectionModule = _$InjectionModule();
  gh.factory<String>(() => injectionModule.signalingServerUrl,
      instanceName: 'baseUrl');
  gh.singleton<_i3.WsServer>(
      _i3.WsServer(get<String>(instanceName: 'baseUrl')));
  gh.singleton<_i4.Signaling>(
      _i4.Signaling(get<String>(instanceName: 'baseUrl')));
  return get;
}

class _$InjectionModule extends _i5.InjectionModule {}
