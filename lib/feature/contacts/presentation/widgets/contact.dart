import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactWidget extends StatelessWidget{
  final String name;
  const ContactWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Text(name)),
            Transform.rotate(
              angle: -2.4,
              child: SvgPicture.asset(
                  'assets/end-call.svg',
                  semanticsLabel: 'Acme Logo',
                  color: Colors.green
              ),
            ),
          ],
        ),
      ),
    );
  }

}