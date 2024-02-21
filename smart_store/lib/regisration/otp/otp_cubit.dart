import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_repository.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());
  final OtpRepository _repository = OtpRepository();

  void verifyOtp({
    required String email,
    required String name,
    required String password,
    required String phone,
    required String otp,
  }) async {
    emit(OtpVerifying());
    _repository.verifyOtp(phone, otp).then(
      (response) {
        _createAccount(
          email: email,
          phone: phone,
          name: name,
          password: password,
        );
      },
    ).catchError(
      (value) {
        DioError error = value;
        if (error.response != null) {
          emit(OtpVerificationFailed(errorMsg: error.response!.data));
        } else {
          if (error.type == DioErrorType.badResponse) {
            emit(OtpVerificationFailed(
                errorMsg: "Please check your internet connection!"));
          } else {
            emit(OtpVerificationFailed(errorMsg: error.message!));
          }
        }
      },
    );
  }

  void _createAccount({
    required String email,
    required String phone,
    required String name,
    required String password,
  }) async {
    emit(OtpVerifying());
    _repository
        .createAccount(
      email: email,
      phone: phone,
      name: name,
      password: password,
    )
        .then(
      (response) {
        emit(OtpVerified(token: response.data['token']));
      },
    ).catchError(
      (value) {
        DioError error = value;
        if (error.response != null) {
          emit(OtpVerificationFailed(errorMsg: error.response!.data));
        } else {
          if (error.type == DioErrorType.badResponse) {
            emit(OtpVerificationFailed(
                errorMsg: "Please check your internet connection!"));
          } else {
            emit(OtpVerificationFailed(errorMsg: error.message!));
          }
        }
      },
    );
  }

  void resendOtp(phone) {
    _repository.resendOtp(phone);
  }
}
