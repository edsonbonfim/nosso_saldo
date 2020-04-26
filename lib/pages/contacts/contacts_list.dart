import 'package:build_context/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nosso_saldo/controllers/contact/contact_bloc.dart';
import 'package:nosso_saldo/pages/contact/contact_page.dart';

import '../../controllers/contacts/contacts_bloc.dart';
import '../../models/friend.dart';
import '../../shared/custom_card.dart';
import '../../shared/friend_tile.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> contacts;

  const ContactsList({
    Key key,
    @required this.contacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!context.isPhone) return _list();

    return RefreshIndicator(
      onRefresh: context.bloc<ContactsBloc>().onRefresh,
      child: _list(),
    );
  }

  Widget _list() {
    return CustomCard(
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) => ContactTile(
          contacts[i],
          onTap: () => _onTap(context, contacts[i]),
        ),
      ),
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
