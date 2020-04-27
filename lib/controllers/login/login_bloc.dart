import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  LoginState get initialState => Login();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is FetchToken) {
      yield LoggingIn();

      try {
        var user = await authenticationBloc.repository.authenticate(
          email: event.email,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(user));
        yield Login();
      } on FormatException catch (ex) {
        yield NotLoggedIn(ex.message);
      }
    }
  }
}
