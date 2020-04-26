import 'package:meta/meta.dart';

import '../../models/friend.dart';

class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsEmpty extends ContactsState {}

class ContactsError extends ContactsState {
  final String message;

  ContactsError({@required this.message});
}

class ContactsSuccess extends ContactsState {
  final List<Contact> contacts;

  ContactsSuccess({@required this.contacts});
}
