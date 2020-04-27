import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../repositories/repository.dart';
import '../controllers.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required this.repository}) : assert(repository != null);

  final UserRepository repository;

  User get user => repository.user;

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      if (repository.user != null) {
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
      await repository.persistUser(event.user);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await event.user.delete();
      yield AuthenticationLogin();
    }
  }
}
