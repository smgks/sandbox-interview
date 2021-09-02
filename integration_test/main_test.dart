import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/core/messages/status.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/pages/contacts.dart';
import 'package:flutter_sandbox/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FakeWSPeer{
  late WebSocketChannel _socket;
  late Timer _timer;
  bool hasOffer = false;
  bool hasStatus = false;


  void connect() {
    _socket = WebSocketChannel.connect(
        Uri.parse(getIt<String>(instanceName: 'baseUrl')));
    _timer = Timer.periodic(Duration(seconds: 3), (time) {
      _socket.sink.add(json.encode(
          Message.status(
              Status(
                  user: 'fakefake0',
                  id: 'fakefake0'
              )).toJson())
      );
    });

    _socket.stream.listen((event) {
      print(event);
      _onMessage(event);
    });
  }

  void close() {
    _timer.cancel();
  }

  void _onMessage(dynamic data) {
    var messageRaw = json.decode(data as String);
    var message = Message.fromJson(messageRaw);
    if (message.type == MessageType.offer) {
      onOffer!(message.content as Offer);
      hasOffer = true;
    } else if (message.type == MessageType.status) {
      hasStatus = true;
    }
  }

  void Function(Offer data)? onOffer;
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('user_cache')
    ..delete('user_cache');
  configureDependencies();


  testWidgets("test call request", (WidgetTester tester) async {
    var fakeWs = FakeWSPeer();
    fakeWs.connect();

    fakeWs.onOffer = (Offer data){
      data = data;
    };
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'testtest');
    await tester.tap(find.byType(MaterialButton));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 10));
    expect(fakeWs.hasStatus, true);
    await tester.pumpAndSettle();
    expect(find.byType(ContactsList), findsOneWidget);

    expect(find.byKey(Key('contact_key')), findsWidgets);
    await tester.tap(find.byKey(Key('contact_key')).first);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 60));

    expect(fakeWs.hasOffer, true);
    await tester.pumpAndSettle();
    expect(find.byType(ContactsList), findsOneWidget);
  }, initialTimeout: Duration(minutes: 2));
}
