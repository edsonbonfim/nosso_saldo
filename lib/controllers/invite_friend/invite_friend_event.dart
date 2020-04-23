import 'package:meta/meta.dart';

abstract class InviteFriendEvent {}

class InviteFriend extends InviteFriendEvent {
  final String emailToInvite;

  InviteFriend({@required this.emailToInvite});
}
