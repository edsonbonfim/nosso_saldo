abstract class AuthenticationState {}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationLogin extends AuthenticationState {}

class AuthenticationSignUp extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}
