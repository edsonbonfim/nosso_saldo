import 'package:meta/meta.dart';

class User {
  final String name;
  final String token;

  User({
    @required this.name,
    @required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      token: json["token"],
    );
  }
}
