import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';
import '../../services/user_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required this.repository}) : assert(repository != null);

  final UserRepository repository;

  User user;

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = repository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationLogin();
      }
    }

    if (event is LoginScreen) {
      yield AuthenticationLogin();
    }

    if (event is SignUpScreen) {
      yield AuthenticationSignUp();
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await repository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await repository.deleteToken();
      yield AuthenticationLogin();
    }
  }
}
