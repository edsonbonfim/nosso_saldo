import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rubber/rubber.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/transaction/transaction_bloc.dart';
import '../../controllers/transaction/transaction_state.dart';
import '../../models/friend.dart';
import '../../models/transaction.dart';
import '../../shared/btn.dart';
import '../../shared/custom_card.dart';
import '../../shared/friend_tile.dart';
import '../../shared/input.dart';
import '../../shared/modal.dart';
import '../../shared/placeholder_container.dart';

class FriendPage extends StatefulWidget {
  final Contact friend;

  const FriendPage({
    Key key,
    @required this.friend,
  }) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  AuthenticationBloc authentication;
  TransactionsBloc transaction;

  TextEditingController cost;
  TextEditingController message;

  RubberAnimationController rubberAnimation;

  @override
  void initState() {
    super.initState();

    authentication = BlocProvider.of<AuthenticationBloc>(context);

    transaction = TransactionsBloc(
      authentication: authentication,
      contact: widget.friend,
    );

    cost = TextEditingController();
    message = TextEditingController();

    rubberAnimation = RubberAnimationController(
      vsync: this,
      upperBoundValue: AnimationControllerValue(pixel: 250),
      duration: Duration(milliseconds: 200),
      dismissable: true,
    );
  }

  @override
  void dispose() {
    transaction.close();
    cost.dispose();
    message.dispose();
    try {
      rubberAnimation.dispose();
    } catch (ex) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Nosso Saldo"),
      ),
      body: RubberBottomSheet(
        animationController: rubberAnimation,
        lowerLayer: RefreshIndicator(
          onRefresh: transaction.onRefresh,
          child: BlocBuilder<TransactionsBloc, TransactionsState>(
            bloc: transaction,
            builder: _success,
          ),
        ),
        upperLayer: _modal(),
      ),
      floatingActionButton: ValueListenableBuilder<AnimationState>(
        valueListenable: rubberAnimation.animationState,
        child: FloatingActionButton(
          onPressed: rubberAnimation.expand,
          child: Icon(Icons.add),
        ),
        builder: (context, value, child) =>
            value == AnimationState.collapsed ? child : SizedBox(),
      ),
    );
  }

  Widget _success(BuildContext context, TransactionsState state) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          ContactTile(widget.friend),
          CustomCard(
            label: "Histórico",
            child: <Widget>(context) {
              if (state is LoaddedTransactions) {
                return _list(context, state.transactions);
              }
              if (state is EmptyTransactions) {
                return _empty(context);
              }
              return _placeholderList(context);
            }(context),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        "Nenhum registro foi encontrado!",
        style: TextStyle(
          color: const Color(0xffA4B3C2),
        ),
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
    Color color = transaction.createdBy == widget.friend.name
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

  Widget _modal() {
    return Modal(
      controller: rubberAnimation,
      label: "Créditos",
      sublabel: "Adicione créditos em relação ao ${widget.friend.name}",
      inputs: [
        Input(
          hintText: "R\$ 5,00",
          controller: cost,
          reverseColor: true,
        ),
        Input(
          hintText: "Mensagem",
          controller: message,
          reverseColor: true,
        ),
      ],
      btn: Btn(
        label: "Salvar",
        onPressed: () {},
      ),
    );
  }
}
