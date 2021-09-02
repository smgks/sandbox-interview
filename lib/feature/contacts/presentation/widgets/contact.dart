import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/pages/call_page.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:flutter_svg/svg.dart';

/// Presents single contact
class ContactWidget extends StatelessWidget {
  final User contact;
  const ContactWidget({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Text(contact.username)),
            InkWell(
              key: Key('contact_key'),
              onTap: () {
                BlocProvider.of<ContactsBloc>(context)
                    .add(DropConnectionEvent());
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallPage(contact),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.rotate(
                  angle: -2.4,
                  child: SvgPicture.asset('assets/end-call.svg',
                      semanticsLabel: 'Acme Logo', color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
