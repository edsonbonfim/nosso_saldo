import 'package:bloc/bloc.dart';

import '../authentication/authentication.dart';
import 'invites_event.dart';
import 'invites_state.dart';

class InvitesBloc extends Bloc<ListInvitesEvent, InvitesState> {
  InvitesBloc(this.authenticationBloc);

  final AuthenticationBloc authenticationBloc;

  @override
  InvitesState get initialState => InitialInvites();

  @override
  Stream<InvitesState> mapEventToState(ListInvitesEvent event) async* {
    if (event is FetchInvites) {
      yield LoadingInvites();

      var friends = await authenticationBloc.repository.getInvites();

      if (friends.isEmpty) {
        yield EmptyInvites();
      } else {
        yield LoadedInvites(friends);
      }
    }
  }
}
