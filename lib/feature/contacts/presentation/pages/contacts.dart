import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/widgets/contact.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  ContactsBloc _bloc = getIt<ContactsBloc>();
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Card(
            child: BlocBuilder<ContactsBloc, ContactsState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is ContactsInitial) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        return ContactWidget(
                          name: state.users.toList()[index].name,
                        );
                      },
                    ),
                  );
                }
                return Container();
              }
            ),
          )
        ),
      ),
    );
  }
}