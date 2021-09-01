import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/call_page/domain/use_cases/initialize_media.dart';
import 'package:flutter_sandbox/feature/call_page/domain/use_cases/media_device.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'call_event.dart';
part 'call_state.dart';

@injectable
class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc(this._initializeMedia, this._mediaDevice) : super(CallInitial());
  final InitializeMedia _initializeMedia;
  final MediaDevice _mediaDevice;
  bool micEnabled = true;
  bool videoEnabled = true;

  @override
  Stream<CallState> mapEventToState(
    CallEvent event,
  ) async* {
    if (event is InitCallEvent){
      yield await prepareCall(
          event
      );
    } else if (event is CameraUpdateEvent){
      yield CallPrepared();
    } else if (event is EndCallEvent){
      await _initializeMedia.stop();
      yield CallEnded();
    } else if (event is MuteAudioEvent){
      micEnabled = _mediaDevice.muteMic(_initializeMedia.localStream);
      yield CallPrepared();
    } else if (event is MuteVideoEvent){
      videoEnabled = _mediaDevice.muteVideo(_initializeMedia.localStream);
      yield CallPrepared();
    } else if (event is SwitchCameraEvent){
      _mediaDevice.switchCamera(_initializeMedia.localStream);
      yield CallPrepared();
    }
  }


  /// Prepare data for calling
  Future<CallPrepared> prepareCall(
      InitCallEvent event
  ) async {
    await _initializeMedia.initializeConnection(
      event.localRender,
      event.remoteRender,
      event.toUser,
      onStreamChanged: (){add(CameraUpdateEvent());}
    );
    await _initializeMedia.startMessaging(offer: event.offer);
    return CallPrepared();
  }
}
