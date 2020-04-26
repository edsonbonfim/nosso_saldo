import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/contacts/contacts_bloc.dart';
import '../../controllers/contacts/contacts_state.dart';
import '../../shared/friend_tile.dart';
import 'contacts_app_bar.dart';
import 'contacts_list.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContactsAppBar(),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: _blocBuilder,
      ),
    );
  }

  Widget _blocBuilder(BuildContext context, ContactsState state) {
    if (state is ContactsLoading) {
      return ContactTile.placeholderList(context, itemCount: 3);
    }

    if (state is ContactsSuccess) {
      return ContactsList(contacts: state.contacts);
    }

    return SizedBox();
  }
}
