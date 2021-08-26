part of 'media_device_bloc.dart';

@immutable
abstract class MediaDeviceState {}

class MediaDeviceInitial extends MediaDeviceState with EquatableMixin {
  final bool isMicOn;
  final bool isCameraOn;

  MediaDeviceInitial({
      this.isMicOn = true,
      this.isCameraOn = true
  });

  MediaDeviceInitial copyWith(bool? isMicOn, bool? isCameraOn){
    return MediaDeviceInitial(
      isMicOn: isMicOn?? this.isMicOn,
      isCameraOn: isCameraOn?? this.isCameraOn
    );
  }

  @override
  List<Object?> get props => [isMicOn,isCameraOn];
}
