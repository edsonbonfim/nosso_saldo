import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nosso_saldo/controllers/signup/signup_state.dart';
import 'package:nosso_saldo/shared/toogle.dart';

import '../../controllers/login/login_bloc.dart';
import '../../controllers/signup/signup_block.dart';
import '../login/login_page.dart';
import 'signup_form.dart';

class SignupPage extends StatefulWidget {
  final LoginBloc loginBloc;

  const SignupPage({Key key, @required this.loginBloc})
      : assert(loginBloc != null),
        super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupBloc signupBloc;

  @override
  void initState() {
    super.initState();
    signupBloc = SignupBloc(loginBloc: widget.loginBloc);
  }

  // @override
  // void dispose() {
  //   signupBloc.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: signupBloc,
        child: BlocListener<SignupBloc, SignupState>(
          listener: _listenerState,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Hero(
                          tag: "logo",
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ),
                      Expanded(
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
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SignupForm(),
                      Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: BlocBuilder<SignupBloc, SignupState>(
                                builder: _loginBtn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listenerState(BuildContext context, SignupState state) {
    if (state is SignupError) {
      Toogle.show(context: context, label: state.message);
    }
  }

  Widget _loginBtn(BuildContext context, SignupState state) {
    return state is SignupLoading
        ? SizedBox()
        : Text(
            "Entrar",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          );
  }
}
