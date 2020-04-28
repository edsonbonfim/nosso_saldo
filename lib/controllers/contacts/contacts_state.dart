import '../../models/models.dart';

abstract class ContactsState {}

class LoadingContacts extends ContactsState {}

class EmptyContacts extends ContactsState {}

class UnloadedContacts extends ContactsState {
  UnloadedContacts(this.message);
  final String message;
}

class LoadedContacts extends ContactsState {
  LoadedContacts(this.contacts);
  final List<Contact> contacts;
}
