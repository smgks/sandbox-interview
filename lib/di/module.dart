import 'package:injectable/injectable.dart';

@module
abstract class InjectionModule {
  @Named('baseUrl')
  String get signalingServerUrl => 'wss://flutter-sandbox-smgks.herokuapp.com';
}
