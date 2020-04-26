import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/friend.dart';
import '../authentication/authentication_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final AuthenticationBloc authentication;
  final Contact contact;

  TransactionsBloc({
    @required this.authentication,
    @required this.contact,
  }) {
    fetchTransactions();
  }

  @override
  TransactionsState get initialState => LoadingTransactions();

  @override
  Stream<TransactionsState> mapEventToState(TransactionsEvent event) async* {
    if (event is FetchTransactions) {
      yield LoadingTransactions();
      try {
        var transactions = await authentication.repository.getTransactions(
          authentication.repository.token,
          contact.id,
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
