import 'dart:async';

import 'package:flutter_sandbox/core/configuration.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/call_state.dart';
import 'package:flutter_sandbox/core/messages/candidate.dart';
import 'package:flutter_sandbox/core/messages/message.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/call_page/domain/repositories/repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

/// Used for media initialization and networking
@injectable
class InitializeMedia {
  final IRepository _repository;
  late RTCPeerConnection peerConnection;
  late MediaStream localStream;
  late MediaStream remoteStream;
  List<RTCIceCandidate> candidates = [];
  late Timer _keepAliveTimer;
  void Function()? onEndCall;
  DateTime lastAlive = DateTime.now();
  User? toUser;
  bool established = false;

  late void Function() onStreamChanged;

  InitializeMedia(this._repository);

  /// prepare remote and local RTCVideoRenderer,
  /// create localStream
  Future<void> _initializeMedia(
      RTCVideoRenderer local, RTCVideoRenderer remote) async {
    local.initialize();
    remote.initialize();
    localStream = await navigator.mediaDevices
        .getUserMedia(Configuration.mediaConstraints);
    local.srcObject = localStream;
    remoteStream = await createLocalMediaStream('key');
  }

  /// Send all candidates when connection established
  void _sendCandidates() {
    candidates.forEach((element) {
      _addCandidate(element);
    });
    established = true;
  }

  /// Initialize networking and RTCVideoRenderer
  Future<void> initializeConnection(
      RTCVideoRenderer local, RTCVideoRenderer remote, User toUser,
      {onStreamChanged}) async {
    this.onStreamChanged = onStreamChanged;
    this.toUser = toUser;

    await _initializeMedia(local, remote);

    _repository.init(_onMessageEvent);

    peerConnection = await createPeerConnection(Configuration.configuration);

    localStream.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream);
    });

    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      if (established) _addCandidate(candidate);
      candidates.add(candidate);
    };

    peerConnection.onTrack = (RTCTrackEvent event) {
      event.streams[0].getTracks().forEach((element) {
        remoteStream.addTrack(element);
      });
      if (event.track.kind == 'video') {
        remote.srcObject = event.streams[0];
        onStreamChanged();
      }
      onStreamChanged();
    };
  }

  /// Check if remote connection is still alive
  void _keepAliveEvent() {
    var timeDiff = DateTime.now().millisecondsSinceEpoch -
        lastAlive.millisecondsSinceEpoch;
    if (timeDiff >= 50000) {
      if (onEndCall != null) {
        onEndCall!();
      }
    }
    _repository.send(Message.callState(CallState(state: 'keepAlive'),
        from: _repository.getCachedUser(), to: toUser!));
  }

  /// End call and send Message
  void endCall() {
    _repository.send(Message.callState(CallState(state: CallState.cancel),
        from: _repository.getCachedUser(), to: toUser!));
    _keepAliveTimer.cancel();
  }

  /// Handle CallState messages
  void _onCallStateEvent(CallState state) {
    if (state.state == CallState.keepAlive) {
      lastAlive = DateTime.now();
    } else if (state.state == CallState.cancel) {
      if (onEndCall != null) {
        onEndCall!();
      }
    }
  }

  /// Start messaging
  ///
  /// creates offer / answer
  Future<void> startMessaging({Offer? offer}) async {
    _keepAliveTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _keepAliveEvent();
    });
    if (offer != null) {
      await _onOffer(offer);
    } else {
      await _sendOffer();
    }
  }

  /// Handles all messages
  void _onMessageEvent(Message message) {
    if (message.to == _repository.getCachedUser() && message.from == toUser) {
      switch (message.type) {
        case 'answer':
          {
            _onAnswer(message.content as Offer);
          }
          break;
        case 'candidate':
          {
            _onCandidate(message.content as Candidate);
          }
          break;
        case 'callState':
          {
            _onCallStateEvent(message.content as CallState);
          }
          break;
      }
    }
  }

  /// Send offer to other listener
  ///
  /// and set setLocalDescription
  Future<void> _sendOffer() async {
    var offer = await peerConnection.createOffer(Configuration.pcConstraints);
    await peerConnection.setLocalDescription(offer);
    var message = Message.offer(
        Offer(
          sdp: offer.sdp!,
          type: offer.type!,
        ),
        from: _repository.getCachedUser(),
        to: toUser!);
    _repository.send(message);
  }

  /// Receive offer and setRemoteDescription
  Future<void> _onOffer(Offer offer) async {
    await peerConnection
        .setRemoteDescription(RTCSessionDescription(offer.sdp, offer.type));
    await _sendAnswer();
  }

  /// Send answer and set setLocalDescription
  Future<void> _sendAnswer() async {
    _sendCandidates();
    var answer = await peerConnection.createAnswer(Configuration.pcConstraints);
    await peerConnection.setLocalDescription(answer);
    _repository.send(Message.answer(Offer(sdp: answer.sdp!, type: answer.type!),
        from: _repository.getCachedUser(), to: toUser!));
    onStreamChanged();
  }

  /// Receive answer and set setRemoteDescription
  void _onAnswer(Offer data) {
    _sendCandidates();
    peerConnection
        .setRemoteDescription(RTCSessionDescription(data.sdp, data.type));
    onStreamChanged();
  }

  /// Send candidate to remote
  void _addCandidate(RTCIceCandidate candidate) {
    var candidateModel = Candidate(
      candidate: candidate.candidate ?? '',
      sdpMid: candidate.sdpMid ?? '',
      sdpMlineIndex: candidate.sdpMlineIndex ?? 0,
    );
    var message = Message.candidate(candidateModel,
        from: _repository.getCachedUser(), to: toUser!);
    _repository.send(message);
  }

  /// Receive candidate from remove and add it to peerConnection
  void _onCandidate(Candidate data) {
    var candidate =
        RTCIceCandidate(data.candidate, data.sdpMid, data.sdpMlineIndex);
    peerConnection.addCandidate(candidate);
  }

  Future<void> stop() async {
    localStream.getTracks().forEach((element) {
      element.stop();
    });
    remoteStream.getTracks().forEach((element) {
      element.stop();
    });
    await localStream.dispose();
    await remoteStream.dispose();
    _repository.close();
    peerConnection.close();
  }
}
