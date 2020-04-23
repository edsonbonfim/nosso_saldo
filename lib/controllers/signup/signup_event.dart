import 'package:meta/meta.dart';

abstract class SignupEvent {}

class Signup extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String password2;

  Signup({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.password2,
  });
}
