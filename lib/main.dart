import 'package:flutter/material.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'di/injection.dart';
import 'feature/login_page/presentation/pages/login_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  await Hive.openBox('user_chache');
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
      home: LoginPage(),
    );
  }
}
