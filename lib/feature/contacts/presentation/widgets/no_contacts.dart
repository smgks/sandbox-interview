import 'package:flutter/material.dart';

class EmptyContactWidget extends StatelessWidget{
  const EmptyContactWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Text('No contacts available')),
          ],
        ),
      ),
    );
  }

}