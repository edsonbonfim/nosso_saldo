import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nosso_saldo/controllers/invite/invite.dart';
import 'package:rubber/rubber.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/contacts/contacts_bloc.dart';
import '../../controllers/contacts/contacts_state.dart';
import '../../shared/btn.dart';
import '../../shared/friend_tile.dart';
import '../../shared/input.dart';
import '../../shared/modal.dart';
import '../../shared/toogle.dart';
import 'contacts_app_bar.dart';
import 'contacts_list.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  InviteBloc inviteBloc;
  TextEditingController emailController;
  RubberAnimationController animationController;

  @override
  void initState() {
    super.initState();
    inviteBloc = InviteBloc(context.bloc<AuthenticationBloc>());
    emailController = TextEditingController();
    animationController = RubberAnimationController(
      vsync: this,
      upperBoundValue: AnimationControllerValue(pixel: 220),
      duration: Duration(milliseconds: 200),
      dismissable: true,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    inviteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContactsAppBar(),
      body: BlocListener<InviteBloc, InviteState>(
        bloc: inviteBloc,
        listener: _inviteBlocListener,
        child: RubberBottomSheet(
          animationController: animationController,
          lowerLayer: BlocBuilder<ContactsBloc, ContactsState>(
            builder: _contactsBlocBuilder,
          ),
          upperLayer: _modal(),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<AnimationState>(
        valueListenable: animationController.animationState,
        child: _floatingActionButton(),
        builder: (context, value, child) {
          return value == AnimationState.collapsed ? child : SizedBox();
        },
      ),
    );
  }

  void _inviteBlocListener(BuildContext context, InviteState state) {
    animationController.collapse();
    if (state is InviteStateMessage) {
      if (state is SendedInvite) {
        emailController.clear();
      }
      Toogle.show(
        context: context,
        label: state.message,
        success: state is SendedInvite,
      );
    }
  }

  Widget _contactsBlocBuilder(BuildContext context, ContactsState state) {
    if (state is LoadingContacts) {
      return ContactTile.placeholderList(context, itemCount: 3);
    }

    if (state is LoadedContacts) {
      return ContactsList(contacts: state.contacts);
    }

    return SizedBox();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: animationController.expand,
      child: Icon(Icons.person_add),
    );
  }

  Widget _modal() {
    return Modal(
      controller: animationController,
      label: "Usuários",
      sublabel: "Convidar usuário pelo e-mail",
      inputs: [
        Input(
          hintText: "E-mail",
          controller: emailController,
        ),
      ],
      btn: Btn(
        label: "Convidar",
        onPressed: () => inviteBloc.sendInvite(
          emailToInvite: emailController.text,
        ),
      ),
    );
  }
}
