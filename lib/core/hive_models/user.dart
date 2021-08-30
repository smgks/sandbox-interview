import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_string/random_string.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  User({
    required this.username,
  }) : idString = randomNumeric(16);

  @HiveField(0)
  final String username;

  @HiveField(1)
  final String idString;

  @override
  List<Object?> get props => [username, idString];

  factory User.fromString(String username) => User(username: username);
}