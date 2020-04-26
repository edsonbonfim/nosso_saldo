import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication_bloc.dart';
import 'list_invites_event.dart';
import 'list_invites_state.dart';

enum Invites { accept, reject }

class ListInvitesBloc extends Bloc<ListInvitesEvent, ListInvitesState> {
  final AuthenticationBloc authenticationBloc;

  ListInvitesBloc({@required this.authenticationBloc});

  @override
  ListInvitesState get initialState => ListInvitesInitial();

  @override
  Stream<ListInvitesState> mapEventToState(ListInvitesEvent event) async* {
    if (event is FetchInvites) {
      yield ListInvitesLoading();

      var friends = await authenticationBloc.repository.getInvites();

      if (friends.isEmpty) {
        yield ListInvitesEmpty();
      } else {
        yield ListInvitesSuccess(friends: friends);
      }
    }
  }
}
