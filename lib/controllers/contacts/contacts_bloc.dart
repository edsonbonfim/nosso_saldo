import 'package:bloc/bloc.dart';

import '../../models/friend.dart';
import '../authentication/authentication.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(this.authenticationBloc) {
    fetchContacts();
  }

  final AuthenticationBloc authenticationBloc;

  List<Contact> contacts;

  @override
  ContactsState get initialState => LoadingContacts();

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is FetchContacts) {
      yield LoadingContacts();

      try {
        contacts = await authenticationBloc.repository.getContacts();

        if (contacts.isEmpty) {
          yield EmptyContacts();
          return;
        }

        yield LoadedContacts(contacts);
      } on FormatException catch (ex) {
        UnloadedContacts(ex.message);
      }
    }
  }

  void fetchContacts() => add(FetchContacts());

  Future<void> onRefresh() async => fetchContacts();
}
