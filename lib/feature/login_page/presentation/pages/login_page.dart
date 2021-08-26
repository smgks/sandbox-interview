import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter user name',
                    border: OutlineInputBorder()
                  ),
                  controller: _controller,
                ),
                MaterialButton(
                  onPressed: () {
                    // TODO: go to contacts
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
        ),
      ),
    );
  }

}