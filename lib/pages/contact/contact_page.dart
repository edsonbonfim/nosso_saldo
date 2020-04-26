import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nosso_saldo/controllers/contact/contact_bloc.dart';
import 'package:nosso_saldo/controllers/contact/contact_state.dart';
import 'package:nosso_saldo/models/friend.dart';
import 'package:nosso_saldo/pages/contact/contact_app_bar.dart';
import 'package:nosso_saldo/pages/contact/contact_transactions.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: _blocBuilder,
    );
  }

  Widget _blocBuilder(BuildContext context, ContactState state) {
    if (state is UnselectedContact) {
      return _unselected();
    }

    if (state is SelectedContact) {
      return _selected(state.contact);
    }

    return SizedBox();
  }

  Widget _unselected() {
    return Center(
      child: Text("Selecione um contato para iniciar"),
    );
  }

  Widget _selected(Contact contact) {
    return Scaffold(
      appBar: ContactAppBar(contact),
      body: ContactTransactions(contact),
    );
  }
}
