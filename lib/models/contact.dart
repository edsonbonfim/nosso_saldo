import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class Contact {
  Contact({
    @required this.id,
    @required this.name,
    this.email,
    double myBalance,
  }) {
    setBalance(myBalance);
  }

  final String id;
  final String name;
  final String email;

  final myBalance = ValueNotifier<double>(0.0);

  void setBalance(double value) => myBalance.value = value;

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
