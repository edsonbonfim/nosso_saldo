import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/contact/contact_bloc.dart';
import '../../controllers/contacts/contacts_bloc.dart';
import '../contact/contact_page.dart';
import '../contacts/contacts_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactBloc contactBloc;
  ContactsBloc contactsBloc;

  @override
  void initState() {
    super.initState();
    contactBloc = ContactBloc();
    contactsBloc = ContactsBloc(context.bloc<AuthenticationBloc>());
  }

  @override
  void dispose() {
    contactBloc.close();
    contactsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: contactBloc),
        BlocProvider.value(value: contactsBloc),
      ],
      child: context.isPhone ? ContactsPage() : _notPhoneScreen(),
    );
  }

  Widget _notPhoneScreen() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: ContactsPage(),
        ),
        Expanded(
          flex: 6,
          child: ContactPage(),
        ),
      ],
    );
  }
}
