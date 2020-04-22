import 'package:meta/meta.dart';

class Friend {
  final String id;
  final String name;
  final double myBalance;

  Friend({
    @required this.id,
    @required this.name,
    @required this.myBalance,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json["_id"],
      name: json["friendName"],
      myBalance: double.parse(json["myBalance"].toString()),
    );
  }
}
