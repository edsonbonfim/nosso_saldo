import 'package:meta/meta.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({@required this.message});

  @override
  String toString() => 'LoginFailure { error: $message }';
}
