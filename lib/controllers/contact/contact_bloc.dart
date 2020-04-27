import 'package:bloc/bloc.dart';

import '../../models/friend.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  Contact contact;

  @override
  ContactState get initialState => UnselectedContact();

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is SelectContact) {
      contact = event.contact;
      yield UnselectedContact();
      yield SelectedContact(contact);
    }
  }

  void selectContact(Contact contact) {
    add(SelectContact(contact));
  }
}
