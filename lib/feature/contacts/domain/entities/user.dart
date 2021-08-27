import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String name;
  final String id;

  User(this.name, this.id);

  @override
  List<Object?> get props => [name,id];
}