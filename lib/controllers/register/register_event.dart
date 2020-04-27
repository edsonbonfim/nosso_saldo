import 'package:meta/meta.dart';

abstract class SignupEvent {}

class CreateAccount extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String password2;

  CreateAccount({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.password2,
  });
}
