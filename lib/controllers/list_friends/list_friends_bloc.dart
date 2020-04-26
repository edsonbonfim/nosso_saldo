import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication_bloc.dart';
import 'list_friends_event.dart';
import 'list_friends_state.dart';

class ListFriendsBloc extends Bloc<ListFriendsEvent, ListFriendsState> {
  final AuthenticationBloc authenticationBloc;

  ListFriendsBloc({@required this.authenticationBloc});

  @override
  ListFriendsState get initialState => ListFriendsLoading();

  @override
  Stream<ListFriendsState> mapEventToState(ListFriendsEvent event) async* {
    yield ListFriendsLoading();

    if (event is FetchFriends) {
      yield await authenticationBloc.repository.getFriends();
    }
  }
}
