import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/feature/call_page/data/data_sources/local_datasource.dart';
import 'package:flutter_sandbox/feature/call_page/data/data_sources/ws_source.dart';

/// Repository for messaging
abstract class IRepository{
  final LocalUserDataSource localUserDataSource;
  final WsSource wsSource;


  IRepository(this.localUserDataSource, this.wsSource);

  /// Initialize all connections
  void init(void Function(Message) onMessage);

  /// Close All connections, subscriptions
  void close();

  /// Send message to remote
  void send(Message message);

  /// Get current local user
  User getCachedUser();
}