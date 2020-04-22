import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/login/login_bloc.dart';
import '../../services/user_repository.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
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
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.network(
                      "https://i.imgur.com/QrJfQwV.png",
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
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
