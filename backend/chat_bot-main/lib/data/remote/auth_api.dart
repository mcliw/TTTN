import 'package:dio/dio.dart';
import 'package:smart_home/data/remote/handler/api_handler.dart';


class AuthApi {
  final ApiHandler _apiHandler;

  AuthApi(this._apiHandler);

  // Future<Map<String, dynamic>> login(String email, String password) async {
  //   String? deviceToken;
  //   try {
  //     deviceToken = await FirebaseMessaging.instance.getToken();
  //   } catch (_) {}
  //   final resp = await _apiHandler.post(
  //     '/auth/login',
  //     body: {
  //       'email': email,
  //       'password': password,
  //       'device_token': deviceToken,
  //     },
  //   );
  //   return resp;
  // }

  Future<Map<String, dynamic>> register(
      Map<String, dynamic> params ) async {
    final resp = await _apiHandler.post(
      '/auth/register',
      body: params,
      
    );
    return resp;
  }

  // Future<Map<String, dynamic>> authToken(String refreshToken) async {
  //   final resp = await _apiHandler.post(
  //     '/auth/auth_token',
  //     options: Options(
  //       headers: {
  //         'Authorization': 'Bearer $refreshToken',
  //       },
  //     ),
  //   );
  //   return resp;
  // }

  
}
