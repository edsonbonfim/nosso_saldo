import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/friend.dart';
import '../authentication/authentication_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class ListTransactionBloc extends Bloc<TransactionEvent, ListTransactionState> {
  final AuthenticationBloc authentication;
  final Friend friend;

  ListTransactionBloc({
    @required this.authentication,
    @required this.friend,
  }) {
    fetchTransactions();
  }

  @override
  ListTransactionState get initialState => ListTransactionLoading();

  @override
  Stream<ListTransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is FetchTransactions) {
      yield ListTransactionLoading();
      try {
        var transactions = await authentication.repository.getTransactions(
          authentication.repository.token,
          friend.id,
        );

        if (transactions.isEmpty) {
          yield ListTransactionEmpty();
          return;
        }

        yield ListTransactionSuccess(transactions: transactions);
      } on FormatException catch (ex) {
        yield ListTransactionError(message: ex.message);
      } on Exception {
        yield ListTransactionError(message: "Ocorreu um erro, tente novamente");
      }
    }
  }

  void fetchTransactions() => add(FetchTransactions());

  Future<void> onRefresh() async => fetchTransactions();
}
