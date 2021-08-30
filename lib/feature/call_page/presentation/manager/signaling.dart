import 'dart:convert';

import 'package:flutter_sandbox/core/messages/candidate.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/ws_connection.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/manager/configuration.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@singleton
class Signaling {
  final ConnectionWS _connectionWS;
  WebSocketChannel? signalingWS;
  RTCPeerConnection? peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer? localRender;
  RTCVideoRenderer? remoteRender;

  bool _videoMuted = false;
  bool _micMuted = false;

  Signaling(this._connectionWS);

  void _onMessage(dynamic event) {
    var messageString = json.decode(event);
    var message = Message.fromJson(messageString as Map<String,dynamic>);
    switch (message.type) {
      case 'offer': {
        _onOffer(message.content as Map<String, dynamic>);
      }
      break;
      case 'answer': {
        _onAnswer(message.content as Map<String, dynamic>);
      }
      break;
      case 'candidate': {
        _onCandidate(message.content as Map<String, dynamic>);
      }
      break;
    }
  }

  Future<void> _sendOffer() async {
    var offer = await peerConnection!.createOffer({});
    await peerConnection!.setLocalDescription(offer);
    var message = Message.offer(offer.toMap());
    signalingWS!.sink.add(json.encode(message.toJson()));
  }

  Future<void> _onOffer(Map<String,dynamic> offer) async {
    peerConnection!.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type'])
    );

    _sendAnswer();
  }
  Future<void> _sendAnswer() async {
    var answer = await peerConnection!.createAnswer({});
    await peerConnection!.setLocalDescription(answer);
    signalingWS!.sink.add(
        json.encode(
            Message.answer(answer.toMap())
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
    var message = Message.candidate(candidateModel);
    signalingWS!.sink.add(json.encode(message.toJson()));
  }
  void _onCandidate(Map<String, dynamic> data) {
    var candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMlineIndex']
    );
    peerConnection!.addCandidate(candidate);
  }

  void sendUserAlive(){

  }
  void createCall(String receiverID) {
    _sendOffer();
  }

  Future<void> cretePeerConnection() async {
    peerConnection = await createPeerConnection(Configuration.configuration);
    peerConnection!.onTrack = (event) {
      if (event.track.kind == 'video') {
        remoteRender!.srcObject = event.streams[0];
      }
    };
    _localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, _localStream!);
    });
    localRender!.srcObject = _localStream;
    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _addCandidate(candidate);
    };
  }
  void initializeRenders(RTCVideoRenderer localRender, RTCVideoRenderer remoteRender){
    this.localRender = localRender;
    this.remoteRender = remoteRender;
    localRender.initialize();
    remoteRender.initialize();
  }

  Future<void> initializeMedia() async {
    _localStream = await navigator.mediaDevices.getUserMedia(Configuration.mediaConstraints);
    await switchCamera();
  }

  void establishWSConnection(){
    if (signalingWS != null)
      return;
    // signalingWS = WebSocketChannel.connect(Uri.parse(signalingServerUrl));
    signalingWS!.stream.listen(_onMessage);
  }


  Future<void> switchCamera() async {
    await Helper.switchCamera(_localStream!.getVideoTracks().firstWhere((element) => element.kind == 'video'));
  }

  Future<void> muteVideo() async {
    var videoTrack = _localStream!.getVideoTracks()
        .firstWhere((element) => element.kind == 'video');
    bool enabled = videoTrack.enabled;
    videoTrack.enabled = !enabled;
    _videoMuted = videoTrack.enabled;
  }

  Future<void> muteMic() async {
    bool enabled = _localStream!.getAudioTracks()[0].enabled;
    _localStream!.getAudioTracks()[0].enabled = !enabled;
    _micMuted = _localStream!.getAudioTracks()[0].enabled;
  }

  get isMicMuted => _micMuted;
  get isVideoMuted => _videoMuted;
}


