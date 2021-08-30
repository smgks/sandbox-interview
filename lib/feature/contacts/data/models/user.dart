import 'package:flutter_sandbox/feature/contacts/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String name,
    required String id
  }) : super(name, id);

  factory UserModel.fromJson(Map<String,dynamic> data) => UserModel(
    id: data['name'],
    name: data['id'],
  );

  Map<String, dynamic> toJson() => {
    id: id,
    name: name
  };

  factory UserModel.fromDomain(User user) => UserModel(
      name: user.name,
      id: user.id
  );
}