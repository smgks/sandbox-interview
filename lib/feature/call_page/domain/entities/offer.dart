import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'message.dart';

class Offer extends MsgContentBase{
  Offer({
    required this.sdp,
    required this.type,
    required this.fromID,
    required this.toID,
  });

  final String sdp;
  final String type;
  final String fromID;
  final String toID;

  RTCSessionDescription toRTCSessionDescription() =>
      RTCSessionDescription(sdp, type);
}