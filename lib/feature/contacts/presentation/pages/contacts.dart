import 'package:flutter/material.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/contacts/data/data_sources/ws_source.dart';
import 'package:flutter_svg/svg.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  WsServer server = getIt<WsServer>();
  @override
  void initState(){
    server.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Card(
            child: StreamBuilder<Set<String>>(
              stream: server.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.toList()[index]),
                      trailing: Transform.rotate(
                        angle: -2.4,
                        child: SvgPicture.asset(
                          'assets/end-call.svg',
                          semanticsLabel: 'Acme Logo',
                          color: Colors.green
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          )
        ),
      ),
    );
  }
}