abstract class RegisterState {}

class Register extends RegisterState {}

class Registering extends RegisterState {}

class Unregister extends RegisterState {
  final String message;
  Unregister(this.message);
}
