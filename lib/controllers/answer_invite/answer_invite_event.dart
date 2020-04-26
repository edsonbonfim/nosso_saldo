import 'package:meta/meta.dart';

import '../list_invites/list_invites_bloc.dart';

class AnswerInviteEvent {}

class AnswerInvite extends AnswerInviteEvent {
  final String email;
  final Invites invite;

  AnswerInvite({
    @required this.email,
    @required this.invite,
  });
}
