import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/pages/call_page.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/pages/contacts.dart';
import 'package:flutter_svg/svg.dart';

class CallOffer extends StatelessWidget {
  final User toUser;
  final Offer offer;
  late final Timer _timer;

  CallOffer({Key? key, required this.toUser, required this.offer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _goBack(context);
    });
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      toUser.username + ' is calling you',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          await goToCall(context);
                        },
                        child: Transform.rotate(
                          angle: -2.4,
                          child: SvgPicture.asset('assets/end-call.svg',
                              semanticsLabel: 'Acme Logo'),
                        )),
                    FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () async {
                          await _goBack(context);
                        },
                        child: SvgPicture.asset(
                          'assets/end-call.svg',
                          semanticsLabel: 'Acme Logo',
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goToCall(BuildContext context) async {
    _timer.cancel();
    Future.delayed(Duration.zero).then((value) async {
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              toUser,
              offer: offer,
            ),
          ));
    });
  }

  Future<void> _goBack(BuildContext context) async {
    _timer.cancel();
    Future.delayed(Duration.zero).then((value) async {
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ContactsList(),
          ));
    });
  }
}
