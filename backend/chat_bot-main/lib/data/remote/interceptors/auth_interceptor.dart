import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smart_home/data/local/app_provider.dart';


class AuthInterceptor extends Interceptor {
  final AppProvider _appProvider;

  AuthInterceptor(
    this._appProvider,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Map<String, String> headers = Map.from(options.headers);
    if (headers['Authorization'] == null && _appProvider.hasAccessToken) {
      headers['Authorization'] = 'Bearer ${_appProvider.accessToken}';
    }
    headers['device-type'] = Platform.isAndroid ? 'android' : 'ios';
    options.headers = headers;
    return super.onRequest(options, handler);
  }
}
