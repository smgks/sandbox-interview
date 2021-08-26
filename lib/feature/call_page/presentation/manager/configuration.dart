class Configuration{
  static const mediaConstraints = <String, dynamic>{
    'video': {
      'mandatory': {
        'minWidth':
        '1280',
        'minHeight': '720',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  static const Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun.stunprotocol.org:3478',
          'stun:stun.l.google.com:19302'
        ]
      }
    ]
  };
}