import 'package:dio/dio.dart';
import 'package:smart_store/constants.dart';

class SignupRepository {
  final Dio dio = Dio();

  Future<Response> requestOtp(email, phone) async {
    final response = await dio.post(
      "$BASE_URL/request_otp/",
      data: {'email': email, 'phone': phone},
    );
    return response;
  }
}
