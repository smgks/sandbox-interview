import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

class Env {
  static const local = 'local';
  static const test = 'test';
}

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)

void configureDependencies([String environment = Env.local]) => $initGetIt(getIt, environment: environment);