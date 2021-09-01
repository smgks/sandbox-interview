import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';


@injectable
class MediaDevice {
  // Switch camera
  void switchCamera(MediaStream localStream) {
    Helper.switchCamera(localStream.getVideoTracks()[0]);
  }

  /// Mute mic and return current state
  bool muteMic(MediaStream localStream) {
    bool enabled = localStream.getAudioTracks()[0].enabled;
    localStream.getAudioTracks()[0].enabled = !enabled;
    return !enabled;
  }

  /// Disable video and return current state
  bool muteVideo(MediaStream localStream) {
    bool enabled = localStream.getVideoTracks()[0].enabled;
    localStream.getVideoTracks()[0].enabled = !enabled;
    return !enabled;
  }
}