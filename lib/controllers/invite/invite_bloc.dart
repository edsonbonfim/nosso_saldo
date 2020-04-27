import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication.dart';
import 'invite_event.dart';
import 'invite_state.dart';

class InviteBloc extends Bloc<InviteFriendEvent, InviteState> {
  InviteBloc(this.authenticationBloc);

  final AuthenticationBloc authenticationBloc;

  @override
  InviteState get initialState => InitialInvite();

  @override
  Stream<InviteState> mapEventToState(InviteFriendEvent event) async* {
    yield SendingInvite();

    if (event is SendInvite) {
      try {
        var message = await authenticationBloc.repository.inviteFriend(
          emailToInvite: event.emailToInvite,
        );
        yield SendedInvite(message);
      } on FormatException catch (ex) {
        yield UnsendedInvite(ex.message);
      } on Exception {
        yield UnsendedInvite("Ocorreu um erro, tente novamente!");
      }
    }
  }

  void sendInvite({@required emailToInvite}) {
    add(SendInvite(emailToInvite));
  }
}
