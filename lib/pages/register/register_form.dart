import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../widgets.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _password2Controller;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _password2Controller = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, RegisterState>(
      listener: _listenerState,
      child: Form(
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
            BlocBuilder<SignupBloc, RegisterState>(builder: _signUpBtn),
          ],
        ),
      ),
    );
  }

  Widget _signUpBtn(BuildContext context, RegisterState state) {
    return Btn(
      label: "Cadastrar",
      onPressed: state is! Registering ? _signUp : null,
    );
  }

  void _listenerState(BuildContext context, RegisterState state) {
    if (state is Unregister) {
      Toogle.show(context: context, label: state.message);
    }
  }

  void _signUp() {
    BlocProvider.of<SignupBloc>(context).add(
      CreateAccount(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        password2: _password2Controller.text,
      ),
    );
  }
}
