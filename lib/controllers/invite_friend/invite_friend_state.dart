import 'package:meta/meta.dart';

abstract class InviteFriendState {}

abstract class InviteFriendStateMessage extends InviteFriendState {
  String get message;
}

class InviteFriendInitial extends InviteFriendState {}

class InviteFriendLoading extends InviteFriendState {}

class InviteFriendError extends InviteFriendStateMessage {
  final String message;

  InviteFriendError({@required this.message});
}

class InviteFriendSuccess extends InviteFriendStateMessage {
  final String message;

  InviteFriendSuccess({@required this.message});
}
