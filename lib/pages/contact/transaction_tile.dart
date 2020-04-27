import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosso_saldo/models/transaction.dart';
import 'package:nosso_saldo/shared/placeholder_container.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile(
    this.transaction, {
    Key key,
    this.color = const Color(0xffA4B3C2),
  }) : super(key: key);

  final Transaction transaction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: DefaultTextStyle(
        style: TextStyle(
          fontSize: 10,
          color: const Color(0xffA4B3C2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat.MMMMd().format(transaction.date)),
            Text("via ${transaction.createdBy}"),
          ],
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(transaction.message),
          Text(
            "${transaction.cost.toStringAsFixed(2)}",
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Widget placeholderList([int itemCount = 3]) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (_, __) => placeholder(),
    );
  }

  static Widget placeholder() {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlaceholderContainer(width: 100, height: 8),
          PlaceholderContainer(width: 80, height: 8),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlaceholderContainer(width: 130),
          PlaceholderContainer(width: 50),
        ],
      ),
    );
  }
}
