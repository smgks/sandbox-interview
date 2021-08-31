import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/pages/call_page.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/widgets/contact.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/widgets/no_contacts.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/pages/login_page.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  ContactsBloc _bloc = getIt<ContactsBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bloc.add(LogOutEvent());
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              )
          );
        },
        child: Icon(Icons.logout),
      ),
      body: SafeArea(
        child: Container(
            child: Card(
              child: BlocProvider.value(
                value: _bloc,
                child: BlocBuilder<ContactsBloc, ContactsState>(
                    builder: (context, state) {
                      if (state is ContactsInitial) {
                        if (state.users.length == 0) {
                          return EmptyContactWidget();
                        }
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              return ContactWidget(
                                  contact: state.users.toList()[index]
                              );
                            },
                          ),
                        );
                      }
                      if (state is OfferReceivedState) {
                        BlocProvider.of<ContactsBloc>(context).add(DropConnectionEvent());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallPage(
                                state.from, offer: state.offer,
                              ),
                            )
                        );
                      }
                      return Container();
                    }
                ),
              ),
            )
        ),
      ),
    );
  }
}