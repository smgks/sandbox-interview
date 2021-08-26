import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'media_device_event.dart';
part 'media_device_state.dart';

class MediaDeviceBloc extends Bloc<MediaDeviceEvent, MediaDeviceState> {
  MediaDeviceBloc() : super(MediaDeviceInitial());

  @override
  Stream<MediaDeviceState> mapEventToState(
    MediaDeviceEvent event,
  ) async* {
    if (event is TurnOffMic){

    }
  }
}
