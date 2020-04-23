import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/login/login_bloc.dart';
import '../signup/signup_page.dart';
import 'login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc(
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  // @override
  // void dispose() {
  //   loginBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: loginBloc,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Hero(
                    tag: "logo",
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                ),
                Text.rich(
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
                ),
                Column(
                  children: [
                    LoginForm(),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(
                                    loginBloc: loginBloc,
                                  ),
                                ),
                              );
                            },
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
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
