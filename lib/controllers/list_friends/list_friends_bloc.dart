import 'package:bloc/bloc.dart';

import '../../services/API.dart';
import 'list_friends_event.dart';
import 'list_friends_state.dart';

class ListFriendsBloc extends Bloc<ListFriendsEvent, ListFriendsState> {
  final _apiService = APIService();

  @override
  ListFriendsState get initialState => ListFriendsLoading();

  @override
  Stream<ListFriendsState> mapEventToState(ListFriendsEvent event) async* {
    yield ListFriendsLoading();

    if (event is ListFriendsFetch) {
      yield await _apiService.getFriends(event.token);
    }
  }
}
