import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/login/login_bloc.dart';
import '../../controllers/login/login_event.dart';
import '../../controllers/login/login_state.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: Column(
              children: [
                _input(
                  hintText: "E-mail",
                  controller: _usernameController,
                ),
                _input(
                  hintText: "Senha",
                  controller: _passwordController,
                  obscureText: true,
                ),
                _btn(text: "Entrar", state: state),
              ],
            ),
          );
        },
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
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.secondary,
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
    @required LoginState state,
  }) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
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
        onPressed: state is! LoginLoading ? _onLoginButtonPressed : null,
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        child: state is! LoginLoading
            ? Text(text)
            : SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}
