import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CallOffer extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Card(
                child: ListTile(
                  title: Text('Caller name'),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        // TODO: accept
                      },
                      child: Transform.rotate(
                        angle: -2.4,
                        child: SvgPicture.asset(
                          'assets/end-call.svg',
                          semanticsLabel: 'Acme Logo'
                        ),
                      )
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        // TODO: reject
                      },
                      child: SvgPicture.asset(
                        'assets/end-call.svg',
                        semanticsLabel: 'Acme Logo',
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}