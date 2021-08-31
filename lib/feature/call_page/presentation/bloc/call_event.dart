part of 'call_bloc.dart';

@immutable
abstract class CallEvent {}

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
class EndCallEvent extends CallEvent{

}
class SwitchCameraEvent extends CallEvent{

}
class MuteVideoEvent extends CallEvent{

}
class MuteAudioEvent extends CallEvent{

}
