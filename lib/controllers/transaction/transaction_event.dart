import 'package:nosso_saldo/models/models.dart';
import 'package:nosso_saldo/models/transaction.dart';

class TransactionEvent {}

class SendTransaction extends TransactionEvent {
  SendTransaction(this.contact, this.transaction);
  final Transaction transaction;
  final Contact contact;
}
