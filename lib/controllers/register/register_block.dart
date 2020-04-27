import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication.dart';
import 'register_event.dart';
import 'register_state.dart';

class SignupBloc extends Bloc<SignupEvent, RegisterState> {
  final AuthenticationBloc authenticationBloc;

  SignupBloc({@required this.authenticationBloc})
      : assert(authenticationBloc != null);

  @override
  RegisterState get initialState => Register();

  @override
  Stream<RegisterState> mapEventToState(SignupEvent event) async* {
    if (event is CreateAccount) {
      yield Registering();

      var name = event.name;
      var email = event.email;
      var pass = event.password;
      var pass2 = event.password2;

      if (name.isEmpty || email.isEmpty || pass.isEmpty || pass2.isEmpty) {
        yield Unregister("Preencha todos os campos");
        return;
      }

      if (name.length < 2) {
        yield Unregister("Informe um nome com no mínimo 2 caracteres");
        return;
      }

      var emailRegex =
          r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      bool isValidEmail = RegExp(emailRegex).hasMatch(email);

      if (!isValidEmail) {
        yield Unregister("Informe um e-mail válido");
        return;
      }

      if (pass.length < 5) {
        yield Unregister("Informe uma senha com no mínimo 6 caracteres");
        return;
      }

      if (pass != pass2) {
        yield Unregister("As senhas não são iguais");
        return;
      }

      try {
        await authenticationBloc.repository.signup(
          name: name,
          email: email,
          password: pass,
        );

        var user = await authenticationBloc.repository.authenticate(
          email: email,
          password: pass,
        );

        // make login
        authenticationBloc.add(LoggedIn(user));
      } on FormatException catch (ex) {
        yield Unregister(ex.message);
      } on Exception {
        yield Unregister("Ocorreu um erro, tente novamente");
      }

      yield Register();
    }
  }
}
