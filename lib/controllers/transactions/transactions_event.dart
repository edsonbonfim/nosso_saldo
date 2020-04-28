import 'package:nosso_saldo/models/models.dart';
import 'package:nosso_saldo/models/transaction.dart';

class TransactionsEvent {}

class FetchTransactions extends TransactionsEvent {}

class AddTransaction extends TransactionsEvent {
  AddTransaction(this.contact, this.transaction);
  final Contact contact;
  final Transaction transaction;
}
