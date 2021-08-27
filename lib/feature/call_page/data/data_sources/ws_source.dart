import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:injectable/injectable.dart';

@injectable
class WsSource {
  WsSource(this._connectionWS);

  final ConnectionWS _connectionWS;
}