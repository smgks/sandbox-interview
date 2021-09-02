import 'message.dart';

/// Describes online status
class Status extends MsgContentBase {
  Status({
    required this.user,
    required this.id,
  });

  final String user;
  final String id;

  Map<String, dynamic> toJson() => {
        'user': user,
        'id': id,
      };

  factory Status.fromJson(Map<String, dynamic> data) => Status(
        user: data['user'] as String,
        id: data['id'] as String,
      );
}
