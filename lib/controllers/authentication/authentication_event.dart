import 'package:meta/meta.dart';

abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  LoggedIn({@required this.token});

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoginScreen extends AuthenticationEvent {}

class SignUpScreen extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
