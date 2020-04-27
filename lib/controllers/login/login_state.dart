abstract class LoginState {}

class Login extends LoginState {}

class LoggingIn extends LoginState {}

class NotLoggedIn extends LoginState {
  NotLoggedIn(this.message);
  final String message;
}
