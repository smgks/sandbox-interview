import 'package:flutter_webrtc/flutter_webrtc.dart';

class Candidate {
  Candidate({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMlineIndex,
  });

  final String candidate;
  final String sdpMid;
  final int sdpMlineIndex;

  RTCIceCandidate toRTCIceCandidate() =>
      RTCIceCandidate(candidate, sdpMid,sdpMlineIndex);
}