import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../widgets.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  Contact contact;

  /// New transaction
  TransactionBloc transactionBloc;

  /// List of transactions
  TransactionsBloc transactionsBloc;

  TextEditingController costController;
  TextEditingController messageController;

  RubberAnimationController animationController;

  @override
  void initState() {
    super.initState();

    transactionsBloc = TransactionsBloc(
      authenticationBloc: context.bloc<AuthenticationBloc>(),
      contactBloc: context.bloc<ContactBloc>(),
    );

    transactionBloc = TransactionBloc(transactionsBloc);

    costController = TextEditingController();
    messageController = TextEditingController();

    animationController = RubberAnimationController(
      vsync: this,
      upperBoundValue: AnimationControllerValue(pixel: 250),
      duration: Duration(milliseconds: 200),
      dismissable: true,
    );
  }

  @override
  void dispose() {
    transactionsBloc.close();
    transactionBloc.close();
    costController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: _contactBlocBuilder,
    );
  }

  Widget _contactBlocBuilder(BuildContext context, ContactState state) {
    if (state is UnselectedContact) {
      return _unselected();
    }

    if (state is SelectedContact) {
      contact = state.contact;
      return _selected();
    }

    return SizedBox();
  }

  Widget _unselected() {
    return Material(
      child: Center(
        child: Text("Selecione um contato para iniciar"),
      ),
    );
  }

  Widget _selected() {
    return Scaffold(
      appBar: ContactAppBar(contact),
      body: BlocListener<TransactionBloc, TransactionState>(
        bloc: transactionBloc,
        listener: _transactionBlocListener,
        child: RubberBottomSheet(
          animationController: animationController,
          upperLayer: _modal(),
          lowerLayer: RefreshIndicator(
            onRefresh: transactionsBloc.onRefresh,
            child: BlocBuilder(
              bloc: transactionsBloc..fetchTransactions(),
              builder: _transactionsBlocBuilder,
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<AnimationState>(
        valueListenable: animationController.animationState,
        child: _floatingActionButton(),
        builder: (context, value, child) {
          return value == AnimationState.collapsed ? child : SizedBox();
        },
      ),
    );
  }

  void _transactionBlocListener(BuildContext context, state) {
    animationController.collapse();
    if (state is TransactionStateMessage) {
      if (state is SendedTransaction) {
        costController.clear();
        messageController.clear();
      }
      Toogle.show(
        context: context,
        label: state.message,
        success: state is SendedTransaction,
      );
    }
  }

  Widget _transactionsBlocBuilder(
    BuildContext context,
    TransactionsState state,
  ) {
    if (state is LoadingTransactions) {
      return TransactionTile.placeholderList();
    }

    if (state is LoaddedTransactions) {
      return _listTransactions(state.transactions);
    }

    return SizedBox();
  }

  Widget _listTransactions(List<Transaction> transactions) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (_, i) => _transactionBuilder(transactions[i]),
    );
  }

  Widget _transactionBuilder(Transaction transaction) {
    var userEmail = context.bloc<AuthenticationBloc>().user.email;

    Color color = transaction.createdByEmail == userEmail
        ? const Color(0xff8EF6B1)
        : Theme.of(context).colorScheme.primary;

    return TransactionTile(transaction, color: color);
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: animationController.expand,
      child: Icon(Icons.add),
    );
  }

  Widget _modal() {
    return Modal(
      controller: animationController,
      reverseColor: true,
      label: "Créditos",
      sublabel: "Adicione créditos em relação a ${contact.name}",
      inputs: [
        Input(
          hintText: "R\$ 5,00",
          controller: costController,
          reverseColor: true,
        ),
        Input(
          hintText: "Mensagem",
          controller: messageController,
          reverseColor: true,
        ),
      ],
      btn: Btn(
        label: "Salvar",
        onPressed: () {
          var cost = costController.text.replaceAll(",", ".");
          return transactionBloc.sendTransaction(
            contact,
            Transaction(
              cost: double.parse(cost),
              message: messageController.text,
              date: DateTime.now(),
              createdBy: context.bloc<AuthenticationBloc>().user.name,
              createdByEmail: context.bloc<AuthenticationBloc>().user.email,
            ),
          );
        },
      ),
    );
  }
}
