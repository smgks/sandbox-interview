part of 'media_device_bloc.dart';

@immutable
abstract class MediaDeviceEvent {}

class TurnOffMic extends MediaDeviceEvent {}
class TurnOnMic extends MediaDeviceEvent {}
class TurnOffCamera extends MediaDeviceEvent {}
class TurnOnCamera extends MediaDeviceEvent {}
