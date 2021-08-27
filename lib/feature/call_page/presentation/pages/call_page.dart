import 'package:flutter/material.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/manager/signaling.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final Signaling signaling = getIt<Signaling>();
  RTCVideoRenderer localRender = RTCVideoRenderer();
  RTCVideoRenderer remoteRender = RTCVideoRenderer();

  Future<bool> initialize() async {
    signaling.initializeRenders(localRender, remoteRender);
    await signaling.initializeMedia();
    signaling.establishWSConnection();
    await signaling.cretePeerConnection();
    return true;
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - padding.top - padding.bottom,
                        maxWidth: MediaQuery.of(context).size.width - padding.left - padding.right
                    ),
                    child: AspectRatio(
                      aspectRatio: 9/16,
                      child: RTCVideoView(
                          remoteRender
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              ),
              color: Colors.amber,
            ),
            FutureBuilder<bool>(
              future: initialize(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container(
                  color: Colors.indigo,
                  height: 120,
                  child: AspectRatio(
                    aspectRatio: 9/16,
                    child: RTCVideoView(
                        localRender
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              // _mediaViewController.muteMic();
            },
            tooltip: 'Increment',
            child: SvgPicture.asset(
                // value.audioEnabled ? 'assets/mic-off.svg' :
                'assets/mic-on.svg',
                semanticsLabel: 'Acme Logo'
            ),
          ),
          SizedBox(width: 16,),
          FloatingActionButton(
            onPressed: () {
              // _mediaViewController.muteVideo();
            },
            tooltip: 'Increment',
            child: SvgPicture.asset(
                // value.videoEnabled ? 'assets/video-off.svg' :
               'assets/video-on.svg',
                semanticsLabel: 'Acme Logo'
            ),
          ),
          SizedBox(width: 16,),
          FloatingActionButton(
            onPressed: () async {
              signaling.createCall('123');
              setState(() {});
            },
            tooltip: 'Increment',
            child: SvgPicture.asset(
                'assets/end-call.svg',
                semanticsLabel: 'Acme Logo'
            ),
          ),
        ],
      ),
    );
  }
}