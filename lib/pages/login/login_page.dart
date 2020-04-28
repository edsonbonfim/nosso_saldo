import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/authentication/authentication_event.dart';
import '../../controllers/login/login_bloc.dart';
import '../../controllers/login/login_state.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _logo(),
                _welcome(),
                _form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return SizedBox(
      width: 150,
      height: 150,
      child: Image.asset("assets/images/logo.png"),
    );
  }

  Widget _welcome() {
    return Text.rich(
      TextSpan(
        text: "Bem-vindo ao Nosso Saldo\n",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 2.0,
        ),
        children: [
          TextSpan(
            text: "Controle de finanças entre usuários",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _form() {
    return Column(
      children: [
        LoginForm(),
        SizedBox(height: 5),
        BlocBuilder<LoginBloc, LoginState>(builder: _signUpBtn),
      ],
    );
  }

  Widget _signUpBtn(BuildContext context, LoginState state) {
    if (state is LoggingIn) {
      return FlatButton(child: null, onPressed: null);
    }

    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
              SignUpScreen(),
            ),
            child: Text(
              "Cadastre-se",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
