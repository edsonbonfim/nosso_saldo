import 'package:meta/meta.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupError extends SignupState {
  final String message;

  SignupError({@required this.message});
}
