import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../widgets.dart';

class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: _contactsBuilderBloc,
    );
  }

  Widget _contactsBuilderBloc(BuildContext context, ContactsState state) {
    if (state is LoadingContacts) {
      return ContactTile.placeholderList(context, itemCount: 3);
    }

    if (state is LoadedContacts) {
      return _loadedContacts(context, state.contacts);
    }

    return SizedBox();
  }

  Widget _loadedContacts(BuildContext context, List<Contact> contacts) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          color: context.scaffoldBackgroundColor,
          child: Text(
            "CONTATOS",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        _listContacts(contacts),
      ],
    );
  }

  Widget _listContacts(List<Contact> contacts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, i) => _contactItemBuilder(context, contacts[i]),
    );
  }

  Widget _contactItemBuilder(BuildContext context, Contact contact) {
    return ContactTile(
      contact,
      onTap: () => _onTap(context, contact),
    );
  }

  void _onTap(BuildContext context, Contact contact) {
    context.bloc<ContactBloc>().selectContact(contact);
    if (context.isPhone) {
      context.push(CupertinoPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.bloc<ContactBloc>(),
          child: ContactPage(),
        ),
      ));
    }
  }
}
