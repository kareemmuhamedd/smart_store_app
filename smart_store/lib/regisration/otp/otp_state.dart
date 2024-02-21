abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpVerifying extends OtpState {}

class OtpVerified extends OtpState {
  String token;

  OtpVerified({required this.token});
}

class OtpVerificationFailed extends OtpState {
  String errorMsg;

  OtpVerificationFailed({required this.errorMsg});
}
