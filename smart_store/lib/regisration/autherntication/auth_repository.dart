import 'package:dio/dio.dart';

import '../../constants.dart';
class AuthRepository{

  final Dio dio = Dio();

  Future<Response> getUserData({required String token}) async {
    final response = await dio.get(
      "$BASE_URL/userdata/",
      options: Options(
        headers: {"authorization": "Bearer $token"},
      ),
    );
    return response;
  }
}