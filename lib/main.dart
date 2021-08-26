import 'package:flutter/material.dart';
import 'package:flutter_sandbox/feature/login_page/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'di/injection.dart';
import 'feature/call_page/presentation/pages/call_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('user_chache');
  Hive.registerAdapter<User>(UserAdapter());
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CallPage(),
    );
  }
}
