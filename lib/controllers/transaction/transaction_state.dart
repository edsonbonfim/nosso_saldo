import 'package:meta/meta.dart';

import '../../models/transaction.dart';

class TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError({@required this.message});
}

class TransactionSuccess extends TransactionState {
  final List<Transaction> transactions;

  TransactionSuccess({@required this.transactions});
}
