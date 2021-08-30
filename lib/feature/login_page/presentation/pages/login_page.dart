import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/contacts/presentation/pages/contacts.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/bloc/login_page/login_bloc.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/widgets/idle_content.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/widgets/loading_content.dart';


class LoginPage extends StatelessWidget {
  final bloc = getIt<LoginBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<LoginBloc>.value(
          value: bloc,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginIdle) {
                return IdleContent();
              } else if (state is LoginError){
                Future.delayed(Duration.zero).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message)
                      )
                  );
                });
                return LoadingContent();
              } else if (state is LoginIn) {
                Future.delayed(Duration.zero).then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ContactsList(),)
                  );
                });
                return LoadingContent();
              } else if (state is LoginInitial){
                return LoadingContent();
              }
              throw UnimplementedError();
            },
          ),
        ),
      ),
    );
  }
}
