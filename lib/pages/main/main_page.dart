import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rubber/rubber.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/authentication/authentication_event.dart';
import '../../controllers/invite_friend/invite_friend_bloc.dart';
import '../../controllers/invite_friend/invite_friend_event.dart';
import '../../controllers/invite_friend/invite_friend_state.dart';
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

  // @override
  // void dispose() {
  // try {
  //   addFriendBloc.close();
  //   emailController.dispose();
  //   bottomSheetController?.dispose();
  // } catch (ex) {}
  // super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text("Nosso Saldo"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
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
              upperLayer: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kBottomNavigationBarHeight / 2),
                    topRight: Radius.circular(kBottomNavigationBarHeight / 2),
                  ),
                ),
                child: ListView(
                  physics: ScrollPhysics(),
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xff536180),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Usuários",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffC3DEED),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Convidar usuário pelo e-mail",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xffC3DEED),
                      ),
                    ),
                    _input(
                      hintText: "E-mail do usuário",
                      controller: emailController,
                    ),
                    _btn(text: "Convidar", state: state),
                  ],
                ),
              ),
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

  _input({
    @required String hintText,
    @required TextEditingController controller,
    bool obscureText = false,
  }) {
    var style = TextStyle(fontSize: 12, fontWeight: FontWeight.w300);

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [BoxShadow(color: const Color(0xff19203F))],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          hintStyle: style,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
        controller: controller,
        obscureText: obscureText,
        style: style,
      ),
    );
  }

  _btn({
    @required String text,
    @required InviteFriendState state,
  }) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(230),
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(230),
          ],
        ),
        boxShadow: [BoxShadow(color: const Color(0xff19203F))],
      ),
      child: FlatButton(
        onPressed: () {
          addFriendBloc.add(InviteFriend(
            emailToInvite: emailController.text,
          ));
        },
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        child: state is! InviteFriendLoading
            ? Text(text)
            : SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
