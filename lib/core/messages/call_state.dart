import 'message.dart';

/// Describes online status
class CallState extends MsgContentBase {
  CallState({
    required this.state,
  });
  static const keepAlive = 'keepAlive';
  static const cancel = 'cancel';

  final String state;

  Map<String, dynamic> toJson() => {
        'state': state,
      };

  factory CallState.fromJson(Map<String, dynamic> data) => CallState(
        state: data['state'] as String,
      );
}
