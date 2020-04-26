import 'package:meta/meta.dart';

class Contact {
  final String id;
  final String name;

  String email;
  double myBalance;

  Contact({
    @required this.id,
    @required this.name,
    this.email,
    this.myBalance,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json["_id"],
      name: json["friendName"] ?? json["name"] ?? null,
      myBalance: json["myBalance"] == null
          ? null
          : double.parse(json["myBalance"].toString()),
      email: json["email"] ?? null,
    );
  }
}
