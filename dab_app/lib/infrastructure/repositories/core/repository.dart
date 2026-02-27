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
      return Left(e.toAppFailure);
    } catch (e) {
      return Left(UnknownFailure(originalError: e));
    }
  }
}
