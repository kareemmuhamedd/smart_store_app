abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupSubmitting extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailed extends SignupState {
  String errorMsg;
  SignupFailed({required this.errorMsg});
}
