import 'package:bloc/bloc.dart';
import 'package:smart_store/regisration/signup/signup_reposetory.dart';
import 'package:smart_store/regisration/signup/signup_state.dart';
import 'package:dio/dio.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final SignupRepository _repository = SignupRepository();

  void requestOtp(email, phone) {
    emit(SignupSubmitting());
    _repository
        .requestOtp(email, phone)
        .then((response) => emit(SignupSuccess()))
        .catchError(
      (value) {
        DioException error = value;
        if (error.response != null) {
          emit(SignupFailed(errorMsg: error.response.toString()));
        } else {
          if (error.type == DioExceptionType.badResponse) {
            emit(SignupFailed(
                errorMsg: "Please check your internet connection!"));
          } else {
            emit(SignupFailed(errorMsg: error.message!));
          }
        }
      },
    );
  }
}
