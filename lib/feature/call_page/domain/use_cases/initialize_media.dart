import 'package:flutter_sandbox/core/configuration.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/candidate.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/call_page/domain/repositories/signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';


/// Used for media initialization and networking
@injectable
class InitializeMedia {
  final IRepository _repository;
  RTCPeerConnection? peerConnection;
  late MediaStream localStream;
  User? toUser;

  late void Function() onStreamChanged;

  InitializeMedia(this._repository);

  /// prepare remote and local RTCVideoRenderer,
  /// create localStream
  Future<void> _initializeMedia(
      RTCVideoRenderer local ,
      RTCVideoRenderer remote
  ) async {
    local.initialize();
    remote.initialize();
    localStream = await navigator.mediaDevices.getUserMedia(
        Configuration.mediaConstraints
    );
    local.srcObject = localStream;
  }

  /// Initialize networking and RTCVideoRenderer
  Future<void> initializeConnection(
      RTCVideoRenderer local,
      RTCVideoRenderer remote,
      User toUser, {
        onStreamChanged
      }) async {
     this.onStreamChanged = onStreamChanged;
     this.toUser = toUser;

     await _initializeMedia(local,remote);

     _repository.init(_onMessageEvent);

     peerConnection = await createPeerConnection(Configuration.configuration);

     peerConnection!.onTrack = (event) {
       if (event.track.kind == 'video') {
         remote.srcObject = event.streams[0];
         onStreamChanged();
       }
     };

     localStream.getTracks().forEach((track) {
       peerConnection!.addTrack(track, localStream);
     });

     peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
       _addCandidate(candidate);
     };
  }

  /// Start messaging
  ///
  /// creates offer / answer
  Future<void> startMessaging({Offer? offer}) async {
    if (offer != null) {
      await onOffer(offer.toJson());
    } else {
      await _sendOffer();
    }
  }

  /// Handles all messages
  void _onMessageEvent(Message message){
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

  /// Send offer to other listener
  ///
  /// and set setLocalDescription
  Future<void> _sendOffer() async {
    var offer = await peerConnection!.createOffer(Configuration.dcConstraints);
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

  /// Receive offer and setRemoteDescription
  Future<void> onOffer(Map<String,dynamic> offer) async {
    peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type'])
    );
    await _sendAnswer();
  }

  /// Send answer and set setLocalDescription
  Future<void> _sendAnswer() async {
    var answer = await peerConnection!.createAnswer(Configuration.dcConstraints);
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
    onStreamChanged();
  }

  /// Receive answer and set setRemoteDescription
  void _onAnswer(Map<String,dynamic> data){
    peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type'])
    );
    onStreamChanged();
  }

  /// Send candidate to remote
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

  /// Receive candidate from remove and add it to peerConnection
  void _onCandidate(Map<String, dynamic> data) {
    print('CANDIDATE RECEIVED');
    var candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMlineIndex']
    );
    peerConnection!.addCandidate(candidate);
  }

  Future<void> stop() async {
    localStream.getTracks().forEach((element) {
      element.stop();
    });
    await localStream.dispose();
    _repository.close();
    peerConnection!.close();
  }
}