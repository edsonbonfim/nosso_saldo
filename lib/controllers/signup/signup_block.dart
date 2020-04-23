import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:nosso_saldo/controllers/login/login_event.dart';

import '../login/login_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final LoginBloc loginBloc;

  SignupBloc({@required this.loginBloc});

  @override
  SignupState get initialState => SignupInitial();

  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is Signup) {
      yield SignupLoading();

      var name = event.name;
      var email = event.email;
      var pass = event.password;
      var pass2 = event.password2;

      if (name.isEmpty || email.isEmpty || pass.isEmpty || pass2.isEmpty) {
        yield SignupError(message: "Preencha todos os campos");
        return;
      }

      if (name.length < 2) {
        yield SignupError(
          message: "Informe um nome com no mínimo 2 caracteres",
        );
        return;
      }

      var emailRegex =
          r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      bool isValidEmail = RegExp(emailRegex).hasMatch(email);

      if (!isValidEmail) {
        yield SignupError(message: "Informe um e-mail válido");
        return;
      }

      if (pass.length < 5) {
        yield SignupError(
          message: "Informe uma senha com no mínimo 6 caracteres",
        );
        return;
      }

      if (pass != pass2) {
        yield SignupError(message: "As senhas não são iguais");
        return;
      }

      try {
        await loginBloc.authenticationBloc.userRepository.signup(
          name: name,
          email: email,
          password: pass,
        );

        // make login
        loginBloc.add(Login(
          username: email,
          password: pass,
        ));
      } on FormatException catch (ex) {
        yield SignupError(message: ex.message);
      } on DioError catch (ex) {
        if (ex.response != null) {
          yield SignupError(message: ex.response.data["err"] ?? ex.message);
        } else {
          yield SignupError(message: ex.message);
        }
      } on Exception {
        yield SignupError(message: "Ocorreu um erro, tente novamente");
      }

      yield SignupInitial();
    }
  }
}
