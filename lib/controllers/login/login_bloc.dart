import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_event.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is FetchToken) {
      yield LoginLoading();

      try {
        var token = await authenticationBloc.userRepository.authenticate(
          username: event.email,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: token));
        // yield LoginInitial();
      } on FormatException catch (error) {
        yield LoginFailure(message: error.message);
      }
    }
  }
}
