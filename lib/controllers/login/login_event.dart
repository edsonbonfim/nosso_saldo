import 'package:meta/meta.dart';

abstract class LoginEvent {}

class Login extends LoginEvent {
  final String username;
  final String password;

  Login({
    @required this.username,
    @required this.password,
  });

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}
