import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/transaction.dart';
import '../authentication/authentication_bloc.dart';
import '../contact/contact_bloc.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    @required this.authenticationBloc,
    @required this.contactBloc,
  });

  final AuthenticationBloc authenticationBloc;
  final ContactBloc contactBloc;

  List<Transaction> transactions = [];

  @override
  TransactionsState get initialState => LoadingTransactions();

  @override
  Stream<TransactionsState> mapEventToState(TransactionsEvent event) async* {
    if (event is AddTransaction) {
      yield LoadingTransactions();
      yield LoaddedTransactions(transactions..add(event.transaction));
    }

    if (event is FetchTransactions) {
      yield LoadingTransactions();
      try {
        transactions = await authenticationBloc.repository.getTransactions(
          contactBloc.contact.id,
        );

        if (transactions.isEmpty) {
          yield EmptyTransactions();
          return;
        }

        yield LoaddedTransactions(transactions);
      } on FormatException catch (ex) {
        yield ErrorTransactions(ex.message);
      } on Exception {
        yield ErrorTransactions("Ocorreu um erro, tente novamente");
      }
    }
  }

  void fetchTransactions() => add(FetchTransactions());

  Future<void> onRefresh() async => fetchTransactions();
}
