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


  Map<String,dynamic> toJson() => {
    'sdp':sdp,
    'type':type,
    'fromID':fromID,
    'toID':fromID,
  };

  factory Offer.fromJson(Map<String,dynamic> data) => Offer(
    sdp : data['sdp'] as String,
    type: data['type'] as String,
    fromID: data['fromID'] as String,
    toID: data['toID'] as String,
  );

  factory Offer.fromDomain(Offer parent) => Offer(
    sdp : parent.sdp,
    type: parent.type,
    fromID: parent.fromID,
    toID: parent.toID,
  );
}