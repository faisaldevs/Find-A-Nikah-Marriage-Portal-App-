import 'package:dio/dio.dart';

/// Typed error surfaced to Repositories/ViewModels instead of raw
/// [DioException] — keeps Dio out of the presentation layer.
sealed class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;

  @override
  String toString() => message;
}

class NoConnectionException extends NetworkException {
  const NoConnectionException() : super('No internet connection.');
}

class RequestTimeoutException extends NetworkException {
  const RequestTimeoutException() : super('Request timed out.');
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException(super.message);
}

class ServerException extends NetworkException {
  const ServerException(this.statusCode, super.message);
  final int? statusCode;
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException(super.message);
}

NetworkException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      return const NoConnectionException();
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const RequestTimeoutException();
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 401) {
        return UnauthorizedException(_extractMessage(e) ?? 'Unauthorized.');
      }
      return ServerException(status, _extractMessage(e) ?? 'Server error.');
    case DioExceptionType.cancel:
      return const UnknownNetworkException('Request cancelled.');
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return UnknownNetworkException(e.message ?? 'Unexpected network error.');
  }
}

String? _extractMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return null;
}
