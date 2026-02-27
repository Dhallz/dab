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
            message: data['message'] ?? 'Validation failed',
          );
        }

        // Handle specific server errors
        return ServerFailure(
          message: data is Map
              ? data['message'] ?? 'Server error'
              : 'Server error',
          statusCode: status,
          errorCode: data is Map ? data['code'] : null,
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
