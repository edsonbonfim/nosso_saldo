import 'package:meta/meta.dart';

import '../../models/transaction.dart';

class ListTransactionState {}

class ListTransactionLoading extends ListTransactionState {}

class ListTransactionEmpty extends ListTransactionState {}

class ListTransactionError extends ListTransactionState {
  final String message;

  ListTransactionError({@required this.message});
}

class ListTransactionSuccess extends ListTransactionState {
  final List<Transaction> transactions;

  ListTransactionSuccess({@required this.transactions});
}
