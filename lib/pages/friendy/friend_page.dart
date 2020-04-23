import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/transaction/transaction_bloc.dart';
import '../../controllers/transaction/transaction_event.dart';
import '../../controllers/transaction/transaction_state.dart';
import '../../models/friend.dart';
import '../../models/transaction.dart';
import '../../shared/custom_card.dart';
import '../../shared/friend_tile.dart';

class FriendPage extends StatelessWidget {
  final Friend friend;

  const FriendPage({
    Key key,
    @required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Nosso Saldo"),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        bloc: TransactionBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        )..add(TransactionFetch(friendId: friend.id)),
        builder: (context, state) {
          return _success(context, state);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(Icons.add),
      ),
    );
  }

  _success(BuildContext context, TransactionState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FriendTile(friend: friend),
          CustomCard(
            title: "Histórico",
            child: state is TransactionSuccess
                ? _list(context, state.transactions)
                : _placeholderList(context),
          ),
        ],
      ),
    );
  }

  _placeholderList(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: _placeholder,
      separatorBuilder: (context, index) => Divider(height: 1),
    );
  }

  Widget _placeholder(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _placeholderContainer(
            width: 100,
            height: 8,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          _placeholderContainer(
            width: 80,
            height: 8,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _placeholderContainer(
            width: 130,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          _placeholderContainer(
            width: 50,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }

  _placeholderContainer({double width = 200, double height = 10, Color color}) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }

  _list(BuildContext context, List<Transaction> transactions) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 1),
      itemCount: transactions.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) => _buildItem(context, transactions[index]),
    );
  }

  _buildItem(BuildContext context, Transaction transaction) {
    Color color = transaction.createdBy == friend.name
        ? Theme.of(context).colorScheme.primary
        : const Color(0xff8EF6B1);

    return ListTile(
      contentPadding: EdgeInsets.zero,
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
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
