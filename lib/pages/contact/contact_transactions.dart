import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nosso_saldo/models/transaction.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/transaction/transaction_bloc.dart';
import '../../controllers/transaction/transaction_state.dart';
import '../../models/friend.dart';
import '../../shared/placeholder_container.dart';

class ContactTransactions extends StatefulWidget {
  const ContactTransactions(this.contact, {Key key}) : super(key: key);

  final Contact contact;

  @override
  _ContactTransactionsState createState() => _ContactTransactionsState();
}

class _ContactTransactionsState extends State<ContactTransactions> {
  TransactionsBloc transactionsBloc;

  @override
  void initState() {
    super.initState();
    transactionsBloc = TransactionsBloc(
      authentication: context.bloc<AuthenticationBloc>(),
      contact: widget.contact,
    );
  }

  @override
  void dispose() {
    transactionsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: transactionsBloc.onRefresh,
      child: BlocBuilder(
        bloc: transactionsBloc,
        builder: _blocBuilder,
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, TransactionsState state) {
    if (state is LoadingTransactions) {
      return _placeholderList();
    }

    if (state is LoaddedTransactions) {
      return _list(state.transactions);
    }

    return SizedBox();
  }

  Widget _placeholderList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: _placeholder,
    );
  }

  Widget _placeholder(BuildContext context, int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
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

  Widget _list(List<Transaction> transactions) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (_, i) => _buildItem(transactions[i]),
    );
  }

  Widget _buildItem(Transaction transaction) {
    // Color color = transaction.createdByEmail == context.bloc<AuthenticationBloc>().user
    //     ? Theme.of(context).colorScheme.primary
    //     : const Color(0xff8EF6B1);

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
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
