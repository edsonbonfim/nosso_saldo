import '../../models/models.dart';

abstract class InvitesState {}

class InitialInvites extends InvitesState {}

class LoadingInvites extends InvitesState {}

class EmptyInvites extends InvitesState {}

class UnloadedInvites extends InvitesState {
  UnloadedInvites(this.message);
  final String message;
}

class LoadedInvites extends InvitesState {
  LoadedInvites(this.contacts);
  final List<Contact> contacts;
}
