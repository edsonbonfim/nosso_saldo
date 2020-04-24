import 'package:meta/meta.dart';

abstract class LoginEvent {}

class FetchToken extends LoginEvent {
  final String email;
  final String password;

  FetchToken({
    @required this.email,
    @required this.password,
  });

  @override
  String toString() =>
      'LoginButtonPressed { username: $email, password: $password }';
}
