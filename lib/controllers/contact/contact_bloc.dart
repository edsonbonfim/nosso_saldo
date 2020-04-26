import 'package:bloc/bloc.dart';
import 'package:nosso_saldo/models/friend.dart';

import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  @override
  ContactState get initialState => UnselectedContact();

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is SelectContact) {
      yield UnselectedContact();
      yield SelectedContact(event.contact);
    }
  }

  void selectContact(Contact contact) {
    add(SelectContact(contact));
  }
}
