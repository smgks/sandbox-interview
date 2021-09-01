part of 'call_bloc.dart';

@immutable
abstract class CallEvent {}

/// Initialize call
///
/// Initializes remote renders, networking
class InitCallEvent extends CallEvent{
  final RTCVideoRenderer localRender;
  final RTCVideoRenderer remoteRender;
  final User toUser;
  final Offer? offer;

  InitCallEvent({
      required this.localRender,
      required this.remoteRender,
      required this.toUser,
      this.offer
  });
}

/// End call and push CallEnded state
class EndCallEvent extends CallEvent{}

/// Switch call and push CallPrepared state
class SwitchCameraEvent extends CallEvent{}

/// Push CallPrepared state
class CameraUpdateEvent extends CallEvent{}

/// Mute video and push CallPrepared state
class MuteVideoEvent extends CallEvent{}

/// Mute audio and push CallPrepared state
class MuteAudioEvent extends CallEvent{}
