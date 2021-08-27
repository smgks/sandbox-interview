import 'package:flutter_sandbox/feature/call_page/domain/entities/offer.dart';

class OfferModel extends Offer{
  OfferModel({
    required String sdp,
    required String type,
    required String fromID,
    required String toID,
  }): super(sdp: sdp,type: type,fromID: fromID, toID: toID);


  Map<String,dynamic> toJson() => {
    'sdp':sdp,
    'type':type,
    'fromID':fromID,
    'toID':fromID,
  };

  factory OfferModel.fromJson(Map<String,dynamic> data) => OfferModel(
    sdp : data['sdp'] as String,
    type: data['type'] as String,
    fromID: data['fromID'] as String,
    toID: data['toID'] as String,
  );

  factory OfferModel.fromDomain(Offer parent) => OfferModel(
    sdp : parent.sdp,
    type: parent.type,
    fromID: parent.fromID,
    toID: parent.toID,
  );
}