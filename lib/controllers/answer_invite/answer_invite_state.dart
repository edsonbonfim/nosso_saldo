import 'package:meta/meta.dart';

abstract class AnswerInviteState {}

abstract class AnswerInviteStateMessage extends AnswerInviteState {
  String get message;
}

class AnswerInviteInitial extends AnswerInviteState {}

class AnswerInviteLoading extends AnswerInviteState {}

class AnswerInviteError extends AnswerInviteStateMessage {
  final String message;

  AnswerInviteError({@required this.message});
}

class AnswerInviteSuccess extends AnswerInviteStateMessage {
  final String message;

  AnswerInviteSuccess({@required this.message});
}
