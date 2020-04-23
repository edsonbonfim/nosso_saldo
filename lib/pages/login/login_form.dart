import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nosso_saldo/shared/btn.dart';
import 'package:nosso_saldo/shared/toogle.dart';

import '../../controllers/login/login_bloc.dart';
import '../../controllers/login/login_event.dart';
import '../../controllers/login/login_state.dart';
import '../../shared/input.dart';

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
          Toogle.show(context: context, label: state.error);
        }
      },
      child: Form(
        child: Column(
          children: [
            Input(
              hintText: "E-mail",
              controller: _usernameController,
            ),
            Input(
              hintText: "Senha",
              controller: _passwordController,
              obscureText: true,
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) => Btn(
                label: "Entrar",
                onPressed: state is! LoginLoading ? _login : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _login() {
    BlocProvider.of<LoginBloc>(context).add(
      Login(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}
