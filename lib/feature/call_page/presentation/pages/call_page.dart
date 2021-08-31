import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/di/injection.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/bloc/call_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallPage extends StatelessWidget {
  final User toUser;
  final Offer? offer;
  CallPage(this.toUser, {this.offer});

  final CallBloc bloc = getIt<CallBloc>();
  final RTCVideoRenderer localRender = RTCVideoRenderer();
  final RTCVideoRenderer remoteRender = RTCVideoRenderer();

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: BlocBuilder<CallBloc, CallState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is CallInitial) {
            bloc.add(
                InitCallEvent(
                  localRender: localRender,
                  remoteRender: remoteRender,
                  toUser: toUser,
                  offer: offer
                )
            );
          }
          if (state is CallPrepared) {
            return SafeArea(
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
                  Container(
                    color: Colors.indigo,
                    height: 120,
                    child: AspectRatio(
                      aspectRatio: 9/16,
                      child: RTCVideoView(
                          localRender
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
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