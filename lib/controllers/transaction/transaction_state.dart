import '../../models/transaction.dart';

class TransactionsState {}

class LoadingTransactions extends TransactionsState {}

class EmptyTransactions extends TransactionsState {}

class ErrorTransactions extends TransactionsState {
  ErrorTransactions(this.message);
  final String message;
}

class LoaddedTransactions extends TransactionsState {
  LoaddedTransactions(this.transactions);
  final List<Transaction> transactions;
}
