import 'package:dio/dio.dart';

import '../../../domain/core/failures.dart';

extension OnDioException on DioException {
  /// Maps a [DioException] to an [AppFailure].
  /// This maintains layer separation: the Domain doesn't know about Dio.
  AppFailure get toAppFailure {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(technicalMessage: 'Connection timeout');

      case DioExceptionType.badResponse:
        final status = response?.statusCode;
        final data = response?.data;

        // Handle validation errors (typically 422 or 400)
        if (status == 422 && data is Map<String, dynamic>) {
          final errors =
              (data['errors'] as Map<String, dynamic>?)?.map(
                (key, value) => MapEntry(key, List<String>.from(value as List)),
              ) ??
              {};
          return ValidationFailure(
            errors: errors,
            message: data['error'] ?? data['message'] ?? 'Validation failed',
          );
        }

        return ServerFailure(
          message: _badResponseMessage(data),
          statusCode: status,
          errorCode: data is Map ? data['code']?.toString() : null,
        );

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request cancelled');

      default:
        return UnknownFailure(
          originalError: this,
          message: message ?? 'An unexpected network error occurred',
        );
    }
  }
}

String _badResponseMessage(dynamic data) {
  if (data is Map) {
    final error = data['error'];
    if (error is Map) {
      final nested = error['details'] ?? error['message'];
      if (nested != null && nested.toString().trim().isNotEmpty) {
        return nested.toString();
      }
    }
    final raw = data['details'] ?? error ?? data['message'];
    if (raw is String && raw.trim().isNotEmpty) return raw;
    if (raw != null && raw is! Map) return raw.toString();
  }
  if (data is String && data.trim().isNotEmpty) {
    final trimmed = data.trim();
    if (trimmed.contains("doesn't compute")) {
      return 'Not found';
    }
    return trimmed;
  }
  return 'Server error';
}
