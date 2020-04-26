import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rubber/rubber.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/invite_friend/invite_friend_bloc.dart';
import '../../controllers/invite_friend/invite_friend_state.dart';
import '../../shared/btn.dart';
import '../../shared/input.dart';
import '../../shared/modal.dart';
import '../../shared/toogle.dart';
import '../home/home_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  InviteFriendBloc addFriendBloc;
  TextEditingController emailController;
  RubberAnimationController bottomSheetController;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();

    bottomSheetController = RubberAnimationController(
      vsync: this,
      upperBoundValue: AnimationControllerValue(pixel: 220),
      duration: Duration(milliseconds: 200),
      dismissable: true,
    );

    addFriendBloc = InviteFriendBloc(
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  @override
  void dispose() {
    try {
      addFriendBloc.close();
      emailController.dispose();
      bottomSheetController?.dispose();
    } catch (ex) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: addFriendBloc,
        child: BlocListener<InviteFriendBloc, InviteFriendState>(
          listener: (context, state) {
            bottomSheetController.collapse();
            if (state is InviteFriendStateMessage) {
              if (state is InviteFriendSuccess) {
                emailController.clear();
              }
              Toogle.show(
                context: context,
                label: state.message,
                success: state is InviteFriendSuccess,
              );
            }
          },
          child: BlocBuilder<InviteFriendBloc, InviteFriendState>(
            builder: (context, state) => RubberBottomSheet(
              animationController: bottomSheetController,
              lowerLayer: HomePage(),
              upperLayer: _modal(),
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<AnimationState>(
        valueListenable: bottomSheetController.animationState,
        child: FloatingActionButton(
          onPressed: bottomSheetController.expand,
          child: Icon(Icons.person_add),
        ),
        builder: (context, value, child) =>
            value == AnimationState.collapsed ? child : SizedBox(),
      ),
    );
  }

  Widget _modal() {
    return Modal(
      controller: bottomSheetController,
      label: "Usuários",
      sublabel: "Convidar usuário pelo e-mail",
      inputs: [
        Input(
          hintText: "E-mail",
          controller: emailController,
          reverseColor: true,
        ),
      ],
      btn: Btn(
        label: "Convidar",
        onPressed: () => addFriendBloc.sendInvite(
          emailToInvite: emailController.text,
        ),
      ),
    );
  }
}
