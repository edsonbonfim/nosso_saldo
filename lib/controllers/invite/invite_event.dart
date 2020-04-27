abstract class InviteFriendEvent {}

class SendInvite extends InviteFriendEvent {
  SendInvite(this.emailToInvite);
  final String emailToInvite;
}
