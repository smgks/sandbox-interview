import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_sandbox/core/hive_models/user.dart';
import 'package:flutter_sandbox/core/messages/offer.dart';
import 'package:flutter_sandbox/feature/call_page/domain/use_cases/initialize_media.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'call_event.dart';
part 'call_state.dart';

@injectable
class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc(this._initializeMedia) : super(CallInitial());
  final InitializeMedia _initializeMedia;

  @override
  Stream<CallState> mapEventToState(
    CallEvent event,
  ) async* {
    if (event is InitCallEvent){
      yield await prepareCall(
          event
      );
    }
  }

  Future<CallPrepared> prepareCall(
      InitCallEvent event
  ) async {
    await _initializeMedia.initializeConnection(
      event.localRender,
      event.remoteRender,
      event.toUser
    );
    await _initializeMedia.startMessaging(offer: event.offer);
    return CallPrepared();
  }
}
