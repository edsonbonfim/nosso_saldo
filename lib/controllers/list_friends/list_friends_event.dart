import 'package:meta/meta.dart';

class ListFriendsEvent {}

class ListFriendsFetch extends ListFriendsEvent {
  final String token;

  ListFriendsFetch({@required this.token});
}
