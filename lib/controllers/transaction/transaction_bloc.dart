import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nosso_saldo/controllers/authentication/authentication_bloc.dart';
import 'package:nosso_saldo/controllers/transaction/transaction_event.dart';
import 'package:nosso_saldo/controllers/transaction/transaction_state.dart';
import 'package:nosso_saldo/services/API.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AuthenticationBloc authenticationBloc;
  final _apiService = APIService();

  TransactionBloc({@required this.authenticationBloc});

  @override
  TransactionState get initialState => TransactionLoading();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    yield TransactionLoading();

    if (event is TransactionFetch) {
      yield await _apiService.getTransactions(
        authenticationBloc.userRepository.token,
        event.friendId,
      );
    }
  }
}
