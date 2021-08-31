import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_string/random_string.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  User({
    required this.username,
    required this.idString
  });

  User._({
    required this.username,
  }) : idString = randomNumeric(16);

  @HiveField(0)
  final String username;

  @HiveField(1)
  final String idString;

  @override
  List<Object?> get props => [username, idString];

  factory User.fromString(String username) => User._(username: username);

  Map<String,dynamic> toJson() => {
    'username': username,
    'idString': username,
  };

  factory User.fromJson(Map<String, dynamic> data) => User(
      username: data['username'],
      idString: data['idString']
  );
}