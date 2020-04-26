import 'package:meta/meta.dart';

class Friend {
  final String id;
  final String name;

  String email;
  double myBalance;

  Friend({
    @required this.id,
    @required this.name,
    this.email,
    this.myBalance,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json["_id"],
      name: json["friendName"] ?? json["name"] ?? null,
      myBalance: json["myBalance"] == null
          ? null
          : double.parse(json["myBalance"].toString()),
      email: json["email"] ?? null,
    );
  }
}
