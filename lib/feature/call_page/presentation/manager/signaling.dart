import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sandbox/feature/call_page/domain/entities/message.dart';
import 'package:flutter_sandbox/feature/call_page/presentation/manager/configuration.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:random_string/random_string.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageType {
  static const String offer = 'offer';
  static const String answer = 'answer';
  static const String candidate = 'candidate';
}

@singleton
class Signaling {
  String _id = randomNumeric(12);
  WebSocketChannel? signalingWS;
  RTCPeerConnection? peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer? localRender;
  RTCVideoRenderer? remoteRender;
  final String signalingServerUrl;

  bool _videoMuted = false;
  bool _micMuted = false;

  Signaling(@Named('baseUrl') this.signalingServerUrl);

  void _onMessage(dynamic event) {
    var messageString = json.decode(event);
    var message = Message.fromJson(messageString as Map<String,dynamic>);
    switch (message.type) {
      case MessageType.offer: {
        _onOffer(message.content as Map<String, dynamic>);
      }
      break;
      case MessageType.answer: {
        _onAnswer(message.content as Map<String, dynamic>);
      }
      break;
      case MessageType.candidate: {
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
    Map<String,dynamic> candidateMap = candidate.toMap();
    candidateMap.addEntries([
      MapEntry('from', _id),
    ]);
    var message = Message.candidate(candidateMap);
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
    localRender = localRender;
    remoteRender = remoteRender;
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
    signalingWS = WebSocketChannel.connect(Uri.parse(signalingServerUrl));
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


