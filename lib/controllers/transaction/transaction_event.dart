import 'package:nosso_saldo/models/transaction.dart';

class TransactionEvent {}

class SendTransaction extends TransactionEvent {
  SendTransaction(this.transaction);
  final Transaction transaction;
}
