import 'dart:async';

Future<T> retryableWrapper<T>(
  Future<T> Function() method, {
  required FutureOr<bool> Function(T) retryWhen,
  Duration retryInterval = const Duration(milliseconds: 500),
  Duration timeout = const Duration(seconds: 30),
}) async {
  final startTime = DateTime.now();
  final expiredTime = startTime.add(timeout);
  while (DateTime.now().isBefore(expiredTime)) {
    final res = await method();
    if (await retryWhen(res)) {
      await Future.delayed(retryInterval);
      continue;
    }
    return res;
  }
  throw TimeoutException('Retry timed out');
}
