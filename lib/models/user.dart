import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class User extends HiveObject {
  User({
    @required this.name,
    @required this.email,
    @required this.token,
  });

  final String name;
  final String email;
  final String token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      email: json["email"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "token": token,
    };
  }
}

class UserAdapter extends TypeAdapter<User> {
  @override
  int get typeId => 0;

  @override
  User read(BinaryReader reader) {
    var rawUser = reader.readMap().cast<String, dynamic>();
    return User.fromJson(rawUser);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeMap(obj.toJson());
  }
}
