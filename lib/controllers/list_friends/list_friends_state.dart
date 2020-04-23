import 'package:meta/meta.dart';
import 'package:nosso_saldo/models/friend.dart';

class ListFriendsState {}

class ListFriendsLoading extends ListFriendsState {}

class ListFriendsError extends ListFriendsState {
  final String message;

  ListFriendsError({@required this.message});
}

class ListFriendsSuccess extends ListFriendsState {
  final List<Friend> friends;

  ListFriendsSuccess({@required this.friends});
}
