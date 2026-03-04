import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../core/extensions/dio_extensions.dart';

abstract class Repository {
  /// Wraps a call with standard error handling.
  Future<Either<AppFailure, T>> guardedCall<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on DioException catch (e) {
      print('DEBUG: guardedCall DioException: $e');
      return Left(e.toAppFailure);
    } catch (e, stack) {
      print('DEBUG: guardedCall Unknown Error: $e');
      print('DEBUG: StackTrace: $stack');
      return Left(UnknownFailure(originalError: e));
    }
  }
}
