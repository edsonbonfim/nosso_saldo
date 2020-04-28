import 'package:bloc/bloc.dart';
import 'package:nosso_saldo/models/models.dart';

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

      try {
        var message = await authenticationBloc.repository.sendTransaction(
          event.contact,
          event.transaction,
        );

        yield SendedTransaction(message);

        transactionsBloc.add(AddTransaction(event.contact, event.transaction));
      } on FormatException catch (ex) {
        yield UnsendedTransaction(ex.message);
      } on Exception {
        yield UnsendedTransaction("Ocorreu um erro, tente novamente");
      }

      yield InitialTransaction();
    }
  }

  sendTransaction(Contact contact, Transaction transaction) {
    add(SendTransaction(contact, transaction));
  }
}
