abstract class InviteState {}

abstract class InviteStateMessage extends InviteState {
  String get message;
}

class InitialInvite extends InviteState {}

class SendingInvite extends InviteState {}

class UnsendedInvite extends InviteStateMessage {
  UnsendedInvite(this.message);
  final String message;
}

class SendedInvite extends InviteStateMessage {
  SendedInvite(this.message);
  final String message;
}
