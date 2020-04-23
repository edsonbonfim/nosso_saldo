import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/signup/signup_block.dart';
import '../../controllers/signup/signup_event.dart';
import '../../controllers/signup/signup_state.dart';
import '../../shared/btn.dart';
import '../../shared/input.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   _password2Controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Input(
            hintText: "Nome",
            controller: _nameController,
          ),
          Input(
            hintText: "E-mail",
            controller: _emailController,
          ),
          Input(
            hintText: "Senha",
            controller: _passwordController,
            obscureText: true,
          ),
          Input(
            hintText: "Confirmar senha",
            controller: _password2Controller,
            obscureText: true,
          ),
          BlocBuilder<SignupBloc, SignupState>(
            builder: (context, state) => Btn(
              label: "Cadastrar",
              onPressed: state is! SignupLoading ? _signup : null,
            ),
          ),
        ],
      ),
    );
  }

  _signup() {
    BlocProvider.of<SignupBloc>(context).add(
      Signup(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        password2: _password2Controller.text,
      ),
    );
  }
}
