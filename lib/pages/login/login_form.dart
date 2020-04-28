import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/login/login_bloc.dart';
import '../../controllers/login/login_event.dart';
import '../../controllers/login/login_state.dart';
import '../../shared/btn.dart';
import '../../shared/input.dart';
import '../../shared/toogle.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: _listenerState,
      child: Form(
        child: Column(
          children: [
            Input(
              hintText: "E-mail",
              controller: _emailController,
            ),
            SizedBox(height: 10),
            Input(
              hintText: "Senha",
              controller: _passwordController,
              obscureText: true,
            ),
            SizedBox(height: 10),
            BlocBuilder<LoginBloc, LoginState>(builder: _loginBtn),
          ],
        ),
      ),
    );
  }

  Widget _loginBtn(BuildContext context, LoginState state) {
    return Btn(
      label: "Entrar",
      onPressed: state is! LoggingIn ? _login : null,
    );
  }

  void _listenerState(BuildContext context, LoginState state) {
    if (state is NotLoggedIn) {
      Toogle.show(context: context, label: state.message);
    }
  }

  void _login() {
    BlocProvider.of<LoginBloc>(context).add(
      FetchToken(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
