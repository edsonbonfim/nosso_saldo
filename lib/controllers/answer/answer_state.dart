abstract class AnswerState {}

abstract class AnswerStateMessage extends AnswerState {
  String get message;
}

class InitialAnswer extends AnswerState {}

class SendingAnswer extends AnswerState {}

class UnsendedAnswer extends AnswerStateMessage {
  UnsendedAnswer(this.message);
  final String message;
}

class SendedAnswer extends AnswerStateMessage {
  SendedAnswer(this.message);
  final String message;
}
