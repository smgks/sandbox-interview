import 'package:flutter_sandbox/core/configuration.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/candidate.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/call_page/domain/repositories/signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@injectable
class InitializeMedia {
  final IRepository _repository;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  User? toUser;

  InitializeMedia(this._repository);

  Future<void> _initializeMedia(RTCVideoRenderer local ,RTCVideoRenderer remote) async {
    local.initialize();
    remote.initialize();
    localStream = await navigator.mediaDevices.getUserMedia(Configuration.mediaConstraints);
  }

  Future<void> initializeConnection(
      RTCVideoRenderer local,
      RTCVideoRenderer remote,
      User toUser,
      ) async {
     this.toUser = toUser;
     await _initializeMedia(local,remote);

     _repository.init(onMessageEvent);

     peerConnection = await createPeerConnection(Configuration.configuration);

     peerConnection!.onTrack = (event) {
       if (event.track.kind == 'video') {
         remote.srcObject = event.streams[0];
       }
     };
     localStream!.getTracks().forEach((track) {
       peerConnection!.addTrack(track, localStream!);
     });
     local.srcObject = localStream;
     peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
       _addCandidate(candidate);
     };
  }

  void onMessageEvent(Message message){
    if (message.to == _repository.getCachedUser() && message.from == toUser) {
      switch (message.type) {
        case 'offer': {
          onOffer(message.content.toJson());
        }
        break;
        case 'answer': {
          _onAnswer(message.content.toJson());
        }
        break;
        case 'candidate': {
          _onCandidate(message.content.toJson());
        }
        break;
      }
    }
  }

  Future<void> startMessaging({Offer? offer}) async {
    if (offer != null) {
      await onOffer(offer.toJson());
    } else {
      await sendOffer();
    }
  }

  Future<void> sendOffer() async {
    var offer = await peerConnection!.createOffer({});
    await peerConnection!.setLocalDescription(offer);
    var message = Message.offer(
      Offer(
        sdp: offer.sdp!,
        type: offer.type!,
      ),
      from: _repository.getCachedUser(),
      to: toUser!
    );
    _repository.send(message);
  }
  Future<void> onOffer(Map<String,dynamic> offer) async {
    peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type'])
    );

    _sendAnswer();
  }

  Future<void> _sendAnswer() async {
    var answer = await peerConnection!.createAnswer({});
    await peerConnection!.setLocalDescription(answer);
    _repository.send(
      Message.answer(
          Offer(
            sdp: answer.sdp!,
            type: answer.type!
          ),
          from: _repository.getCachedUser(),
          to: toUser!
      )
    );
  }
  void _onAnswer(Map<String,dynamic> data){
    peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type'])
    );
  }
  void _addCandidate(RTCIceCandidate candidate){
    var candidateModel = Candidate(
      candidate: candidate.candidate ?? '',
      sdpMid: candidate.sdpMid ?? '',
      sdpMlineIndex: candidate.sdpMlineIndex ?? 0,
    );
    var message = Message.candidate(
        candidateModel,
        from: _repository.getCachedUser(),
        to: toUser!
    );
    _repository.send(message);
  }
  void _onCandidate(Map<String, dynamic> data) {
    var candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMlineIndex']
    );
    peerConnection!.addCandidate(candidate);
  }
}