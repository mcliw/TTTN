import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class ApiHandler {
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  });

  Future<dynamic> download(
    String path,
    dynamic savePath, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  });

  String get baseApiUrl;
}

class ApiHandlerImpl implements ApiHandler {
  final Dio _dio;

  ApiHandlerImpl(this._dio);

  Future<T> _transformError<T>(ValueGetter<Future<T>> func) async {
    try {
      return await func();
    } catch (e) {
      throw _apiErrorToInternalError(e);
    }
  }

  dynamic _apiErrorToInternalError(e) {
    if (e is DioException) {
      return e.error;
    }
    return e;
  }

  @override
  String get baseApiUrl => _dio.options.baseUrl;

  @override
  Future delete(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data['data'];
    });
  }

  @override
  Future download(
    String path,
    savePath, {
    body,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return resp.data;
    });
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data['data'];
    });
  }

  @override
  Future patch(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data['data'];
    });
  }

  @override
  Future post(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data['data'];
    });
  }

  @override
  Future put(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data;
    });
  }
}

class ModuleApiHandlerImpl implements ApiHandler {
  final Dio _dio;

  ModuleApiHandlerImpl(this._dio);

  Future<T> _transformError<T>(ValueGetter<Future<T>> func) async {
    try {
      return await func();
    } catch (e) {
      throw _apiErrorToInternalError(e);
    }
  }

  dynamic _apiErrorToInternalError(e) {
    if (e is DioException) {
      return e.error;
    }
    return e;
  }

  @override
  String get baseApiUrl => _dio.options.baseUrl;

  @override
  Future delete(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data;
    });
  }

  @override
  Future download(
    String path,
    savePath, {
    body,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return resp.data;
    });
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data;
    });
  }

  @override
  Future patch(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data;
    });
  }

  @override
  Future post(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data;
    });
  }

  @override
  Future put(
    String path, {
    body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _transformError(() async {
      final resp = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return resp.data;
    });
  }
}
