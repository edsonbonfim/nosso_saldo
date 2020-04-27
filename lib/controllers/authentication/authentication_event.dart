import '../../models/user.dart';

abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoginScreen extends AuthenticationEvent {}

class SignUpScreen extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  LoggedIn(this.user);
  final User user;
}

class LoggedOut extends AuthenticationEvent {
  LoggedOut(this.user);
  final User user;
}
