import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MediaDevice {
  // Switch camera
  void switchCamera(MediaStream localStream) {
    Helper.switchCamera(localStream.getVideoTracks()[0]);
  }

  /// Mute mic and return current state
  void muteMic(MediaStream localStream, bool enable) {
    localStream.getAudioTracks().forEach((element) {
      element.enabled = enable;
    });
  }

  /// Disable video and return current state
  bool muteVideo(MediaStream localStream) {
    bool enabled = localStream.getVideoTracks()[0].enabled;
    localStream.getVideoTracks()[0].enabled = !enabled;
    return !enabled;
  }
}
