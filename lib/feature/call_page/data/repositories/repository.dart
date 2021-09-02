import 'dart:async';

import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/feature/call_page/data/data_sources/local_datasource.dart';
import 'package:flutter_sandbox/feature/call_page/data/data_sources/ws_source.dart';
import 'package:flutter_sandbox/feature/call_page/domain/repositories/repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IRepository)
class Repository extends IRepository {
  Repository(LocalUserDataSource localUserDataSource, WsSource wsSource)
      : super(localUserDataSource, wsSource);
  late StreamSubscription _subscription;

  void send(Message message) {
    wsSource.send(message);
  }

  void init(void Function(Message) onMessage) {
    wsSource.init();
    _subscription = wsSource.messages.listen(onMessage);
  }

  void close() {
    _subscription.cancel();
    wsSource.close();
  }

  User getCachedUser() => localUserDataSource.receiveCached();
}
