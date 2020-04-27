import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../widgets.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignupBloc>(
        create: (context) => SignupBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _logo(),
        _welcome(),
      ],
    );
  }

  Widget _logo() {
    return Expanded(
      flex: 2,
      child: Image.asset("assets/images/logo.png"),
    );
  }

  Widget _welcome() {
    return Expanded(
      flex: 8,
      child: Container(
        padding: EdgeInsets.only(left: 20),
        child: Text.rich(
          TextSpan(
            text: "Cadastro\n",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1.7,
            ),
            children: [
              TextSpan(
                text: "Crie sua conta Nosso Saldo",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      children: [
        SignupForm(),
        BlocBuilder<SignupBloc, RegisterState>(
          builder: _loginBtn,
        ),
      ],
    );
  }

  Widget _loginBtn(BuildContext context, RegisterState state) {
    if (state is Registering) {
      return FlatButton(child: null, onPressed: null);
    }

    return Row(
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(
              LoginScreen(),
            ),
            child: Text(
              "Entrar",
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
