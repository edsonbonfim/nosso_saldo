import 'package:bloc/bloc.dart';

import '../../models/friend.dart';
import '../authentication/authentication_bloc.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(this.authenticationBloc) {
    fetchContacts();
  }

  final AuthenticationBloc authenticationBloc;

  List<Contact> contacts;

  @override
  ContactsState get initialState => ContactsLoading();

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is FetchContacts) {
      yield ContactsLoading();

      try {
        contacts = await authenticationBloc.repository.getContacts();

        if (contacts.isEmpty) {
          yield ContactsEmpty();
          return;
        }

        yield ContactsSuccess(contacts: contacts);
      } on FormatException catch (ex) {
        ContactsError(message: ex.message);
      }
    }
  }

  void fetchContacts() => add(FetchContacts());

  Future<void> onRefresh() async => fetchContacts();
}
