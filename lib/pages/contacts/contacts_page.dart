import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../widgets.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  InviteBloc inviteBloc;
  InvitesBloc invitesBloc;

  TextEditingController emailController;
  RubberAnimationController animationController;

  @override
  void initState() {
    super.initState();

    inviteBloc = InviteBloc(context.bloc<AuthenticationBloc>());
    invitesBloc = InvitesBloc(context.bloc<AuthenticationBloc>());

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
    inviteBloc.close();
    invitesBloc.close();

    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: ContactsAppBar(),
      body: BlocProvider.value(
        value: invitesBloc,
        child: BlocListener<InviteBloc, InviteState>(
          bloc: inviteBloc,
          listener: _inviteBlocListener,
          child: RubberBottomSheet(
            animationController: animationController,
            lowerLayer: RefreshIndicator(
              onRefresh: () async {
                invitesBloc.onRefresh();
                context.bloc<ContactsBloc>().onRefresh();
              },
              child: ListView(
                children: [
                  ContactsInvites(),
                  ContactsList(),
                ],
              ),
            ),
            upperLayer: _modal(),
          ),
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

  Widget _floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: context.scaffoldBackgroundColor,
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
