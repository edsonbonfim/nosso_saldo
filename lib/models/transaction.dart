import 'package:meta/meta.dart';

class Transaction {
  final double cost;
  final String message;
  final DateTime date;
  final String createdBy;
  final String createdByEmail;

  Transaction({
    @required this.cost,
    @required this.message,
    @required this.date,
    @required this.createdBy,
    @required this.createdByEmail,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var date = (json["date"] as String).split(r"/");
    return Transaction(
      cost: double.parse(json["cost"].toString().replaceAll(",", ".")),
      message: json["message"],
      date: DateTime.parse("2020-${date[1]}-${date[0]}"),
      createdBy: json["createdBy"],
      createdByEmail: json["createdByEmail"],
    );
  }
}
