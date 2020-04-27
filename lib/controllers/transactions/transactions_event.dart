import 'package:nosso_saldo/models/transaction.dart';

class TransactionsEvent {}

class FetchTransactions extends TransactionsEvent {}

class AddTransaction extends TransactionsEvent {
  AddTransaction(this.transaction);
  final Transaction transaction;
}
