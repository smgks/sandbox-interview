import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/feature/call_page/data/data_sources/local_datasource.dart';
import 'package:flutter_sandbox/feature/call_page/data/data_sources/ws_source.dart';

abstract class IRepository{
  final LocalUserDataSource localUserDataSource;
  final WsSource wsSource;

  IRepository(this.localUserDataSource, this.wsSource);

  void init(void Function(Message) onMessage);
  void close();
  void send(Message message);
  User getCachedUser();
}