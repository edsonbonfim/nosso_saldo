abstract class TransactionState {}

abstract class TransactionStateMessage extends TransactionState {
  String get message;
}

class InitialTransaction extends TransactionState {}

class SendingTransaction extends TransactionState {}

class UnsendedTransaction extends TransactionStateMessage {
  UnsendedTransaction(this.message);
  final String message;
}

class SendedTransaction extends TransactionStateMessage {
  SendedTransaction(this.message);
  final String message;
}
