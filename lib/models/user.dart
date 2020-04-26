import 'package:meta/meta.dart';

class User {
  final String name;
  final String token;
  final String email;

  User({
    @required this.name,
    @required this.token,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      token: json["token"],
    );
  }
}
