import 'package:dio/dio.dart';

import '../../constants.dart';

class OtpRepository {
  final Dio dio = Dio();

  Future<Response> verifyOtp(phone, otp) async {
    final response = await dio.post(
      '$BASE_URL/verify_otp/',
      data: {
        'phone': phone,
        'otp': otp,
      },
    );
    return response;
  }

  Future<Response> createAccount({
    required String email,
    required String phone,
    required String name,
    required String password,
  }) async {
    final response = await dio.post(
      '$BASE_URL/create_account/',
      data: {
        'email': email,
        'phone': phone,
        'fullname': name,
        'password': password,
      },
    );
    return response;
  }

  void resendOtp(phone) async {
    await dio.post(
      '$BASE_URL/resend_otp/',
      data: {
        'phone': phone,
      },
    );
  }
}
