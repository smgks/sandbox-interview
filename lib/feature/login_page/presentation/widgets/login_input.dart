import 'package:flutter/material.dart';
import 'package:flutter_sandbox/feature/login_page/presentation/widgets/validators/user_name_validator.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({
    required this.formKey,
    required TextEditingController controller,
  }) : _controller = controller, super();
  final GlobalKey formKey;

  final TextEditingController _controller;

  String? get text => _controller.text;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        decoration: InputDecoration(
            hintText: 'Enter user name',
            border: OutlineInputBorder()
        ),
        controller: _controller,
        validator: userNameValid,
      ),
    );
  }
}