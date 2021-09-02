import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'message.dart';

/// RTCSessionDescription offer wrapper
class Offer extends MsgContentBase {
  Offer({
    required this.sdp,
    required this.type,
  });

  final String sdp;
  final String type;

  RTCSessionDescription toRTCSessionDescription() =>
      RTCSessionDescription(sdp, type);

  Map<String, dynamic> toJson() => {
        'sdp': sdp,
        'type': type,
      };

  factory Offer.fromJson(Map<String, dynamic> data) => Offer(
        sdp: data['sdp'] as String,
        type: data['type'] as String,
      );

  factory Offer.fromDomain(Offer parent) => Offer(
        sdp: parent.sdp,
        type: parent.type,
      );
}
