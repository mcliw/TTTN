import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_home/app_config.dart';
import 'package:smart_home/data/remote/auth_api.dart';
import 'package:smart_home/data/remote/handler/api_handler.dart';
import 'package:smart_home/data/remote/interceptors/auth_interceptor.dart';
import 'package:smart_home/data/remote/interceptors/error_interceptor.dart';
import 'package:smart_home/data/remote/module_api.dart';


dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future parseJson(String text) {
  return compute(_parseAndDecode, text);
}

Dio _buildApiDio(List<Interceptor> interceptors) {
  final dio = Dio()
    ..options.baseUrl = GetIt.I<AppConfig>().baseApiUrl
    ..options.contentType = 'application/json'
    ..options.connectTimeout = const Duration(seconds: 30)
    ..interceptors.addAll(interceptors);
  return dio;
}

Dio _buildModuleDio(List<Interceptor> interceptors) {
  final dio = Dio()
    ..options.baseUrl = GetIt.I<AppConfig>().baseModuleApiUrl
    ..options.contentType = 'application/json'
    ..options.connectTimeout = const Duration(seconds: 30)
    ..interceptors.addAll(interceptors);
  return dio;
}

Future<void> registerRemoteModules(GetIt getIt) async {
  getIt
    ..registerLazySingleton(() => AuthInterceptor(getIt()))
    ..registerLazySingleton(() => ErrorInterceptor(getIt()))
    ..registerLazySingleton(() => LogInterceptor(
          requestBody: false,
          request: false,
          requestHeader: false,
          responseBody: kDebugMode,
          responseHeader: false,
        ))
    ..registerLazySingleton(() {
      final _interceptors = <Interceptor>[
        getIt<AuthInterceptor>(),
        getIt<LogInterceptor>(),
        getIt<ErrorInterceptor>(),
      ];
      return ApiHandlerImpl(_buildApiDio(_interceptors));
    })
    ..registerLazySingleton(() {
      final _interceptors = <Interceptor>[
        getIt<LogInterceptor>(),
        getIt<ErrorInterceptor>(),
      ];
      return ModuleApiHandlerImpl(_buildModuleDio(_interceptors));
    })
    ..registerLazySingleton(
      () => ModuleApi(
        apiHandler: getIt<ApiHandlerImpl>(),
        moduleApiHandler: getIt<ModuleApiHandlerImpl>(),
      ),
    )
    ..registerLazySingleton(
      () => AuthApi(getIt<ApiHandlerImpl>()),
    );
}
