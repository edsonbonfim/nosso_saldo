import 'package:bloc/bloc.dart';

import '../../models/transaction.dart';
import '../authentication/authentication.dart';
import '../transactions/transactions.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(this.transactionsBloc);

  final TransactionsBloc transactionsBloc;

  AuthenticationBloc get authenticationBloc =>
      transactionsBloc.authenticationBloc;

  @override
  TransactionState get initialState => InitialTransaction();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is SendTransaction) {
      yield SendingTransaction();
      yield SendedTransaction("Cadastrado");
    }
  }

  sendTransaction(Transaction transaction) {
    add(SendTransaction(transaction));
    transactionsBloc.add(AddTransaction(transaction));
  }
}
