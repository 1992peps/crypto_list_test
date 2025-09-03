import 'dart:async';
import 'package:dio/dio.dart';

/// Простой retry с экспоненциальным backoff.
/// Не лезем в излишнюю сложность, но покрываем rate limit/5xx.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.retries = 3,
    this.retryCodes = const {500, 502, 503, 504},
    Duration? baseDelay,
  })  : _dio = dio,
        _baseDelay = baseDelay ?? const Duration(milliseconds: 500);

  final Dio _dio;
  final int retries;
  final Set<int> retryCodes;
  final Duration _baseDelay;

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    const retryKey = 'retry_attempt';
    final status = err.response?.statusCode;
    final attempt = (err.requestOptions.extra[retryKey] as int?) ?? 0;

    final canRetry = status != null &&
        retryCodes.contains(status) &&
        attempt < retries;

    if (!canRetry) return super.onError(err, handler);

    await Future<void>.delayed(_baseDelay * (1 << attempt)); // backoff

    final options = err.requestOptions.copyWith(
      extra: {
        ...err.requestOptions.extra,
        retryKey : attempt + 1,
      },
    );

    try {
      final response = await _dio.fetch(options);
      return handler.resolve(response);
    } catch (e) {
      return super.onError(e is DioException ? e : err, handler);
    }
  }
}
