import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends Equatable {
  User({
    required this.username,
  });

  @HiveField(0)
  final String username;

  @override
  List<Object?> get props => [username];
}