import 'package:meta/meta.dart';

enum Invites { accept, reject }

abstract class AnswerInviteEvent {}

class SendAnswer extends AnswerInviteEvent {
  SendAnswer({
    @required this.email,
    @required this.invite,
  });

  final String email;
  final Invites invite;
}
