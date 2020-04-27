abstract class AnswerInviteState {}

abstract class AnswerInviteStateMessage extends AnswerInviteState {
  String get message;
}

class InitialAnswer extends AnswerInviteState {}

class SendingAnswer extends AnswerInviteState {}

class UnsendedAnswer extends AnswerInviteStateMessage {
  UnsendedAnswer(this.message);
  final String message;
}

class SendedAnswer extends AnswerInviteStateMessage {
  SendedAnswer(this.message);
  final String message;
}
