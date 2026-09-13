import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_health_repository.dart';
import '../postgres/postgres_client.dart';

class PostgresHealthRepository implements AbsIHealthRepository {
  final PostgresClient _client;

  PostgresHealthRepository(this._client);

  @override
  Future<Either<DatabaseFailure, bool>> checkConnection() async {
    try {
      await _client.pool.execute('SELECT 1');
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure('Database connection failed: \$e'));
    }
  }
}
