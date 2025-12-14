import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/data/local/app_provider.dart';
import 'package:smart_home/data/remote/exceptions/app_exception_state.dart';
import 'package:smart_home/data/remote/exceptions/exceptions.dart';


class ErrorInterceptor extends Interceptor {
  final AppProvider appProvider;
  final StreamController<CurrentAppExceptionState> _controller = StreamController.broadcast();

  StreamSubscription listenError(ValueChanged<CurrentAppExceptionState> onError) {
    return _controller.stream.listen((event) => onError(event));
  }

  ErrorInterceptor(this.appProvider);

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   final _resp = response.data;
  //   if (_resp is Map && _resp['error'] != null) {
  //     return handler.reject(
  //       DioException(response: response, requestOptions: response.requestOptions),
  //       true,
  //     );
  //   }
  //   super.onResponse(response, handler);
  // }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      if (err.requestOptions.extra['ignore_error_check'] ?? false) {
        return handler.resolve(err.response!);
      }
      _handleErrorResponse(err.response!);
    }
    return super.onError(err, handler);
  }

  void _handleErrorResponse(Response<dynamic> response) {
    if (response.statusCode == 500) {
      throw InternalServerException();
    }
    if (response.statusCode == 401) {
      if (appProvider.hasAccessToken) {
        appProvider.setAccessToken(null);
        _controller.add(CurrentAppExceptionState(state: AppExceptionState.sessionExpired));
        return;
      }
    }
    dynamic data = response.data;
    if (data is String) {
      data = jsonDecode(data) as Map;
    }
    final String? code = data['error_code'];
    final message = data['message'];
    if (code != null) {
      switch (code) {
        default:
          throw ApiException(message, code);
      }
    }
  }
}
