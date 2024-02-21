abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {}

class AuthenticationFailed extends AuthState {
  String errorMsg;

  AuthenticationFailed({required this.errorMsg});
}

class LoggedOut extends AuthState{}
