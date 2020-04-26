import 'package:meta/meta.dart';

import '../../models/friend.dart';

class ListInvitesState {}

class ListInvitesInitial extends ListInvitesState {}

class ListInvitesLoading extends ListInvitesState {}

class ListInvitesEmpty extends ListInvitesState {}

class ListInvitesError extends ListInvitesState {
  final String message;

  ListInvitesError({@required this.message});
}

class ListInvitesSuccess extends ListInvitesState {
  final List<Contact> friends;

  ListInvitesSuccess({@required this.friends});
}
