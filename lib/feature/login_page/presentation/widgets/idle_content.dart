import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/bloc/login_page/login_bloc.dart';

import 'login_input.dart';

class IdleContent extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  IdleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LoginInput(controller: _controller, formKey: formKey,),
            MaterialButton(
              onPressed: () {
                if (formKey.currentState!.validate()){
                  BlocProvider.of<LoginBloc>(context).add(
                      LoginNew(_controller.text)
                  );
                }
              },
              child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 32
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}