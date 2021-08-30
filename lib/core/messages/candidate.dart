import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'message.dart';

class Candidate extends MsgContentBase{
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

  Map<String,dynamic> toJson() => {
    'candidate':candidate,
    'sdpMid':sdpMid,
    'sdpMlineIndex':sdpMlineIndex,
  };

  factory Candidate.fromJson(Map<String,dynamic> data) => Candidate(
    candidate : data['candidate'] as String,
    sdpMid: data['sdpMid'] as String,
    sdpMlineIndex: data['sdpMlineIndex'] as int,
  );
}