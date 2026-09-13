import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';
import '../postgres/app_database.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of global system settings storage in the API.
/// CONTRACT: Implements [AbsISystemSettingsRepository] using Drift [AppDatabase].
class SystemSettingsRepository implements AbsISystemSettingsRepository {
  final AppDatabase _db;

  SystemSettingsRepository(this._db);

  @override
  Future<Either<Failure, String?>> getSetting(String key) async {
    try {
      final query = _db.select(_db.systemSettingsTable)
        ..where((t) => t.key.equals(key));
      final result = await query.getSingleOrNull();
      return Right(result?.value);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get system setting "$key": $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setSetting(String key, String value) async {
    try {
      await _db.into(_db.systemSettingsTable).insertOnConflictUpdate(
            SystemSettingsTableCompanion(
              key: Value(key),
              value: Value(value),
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to set system setting "$key": $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isDomainValidationEnabled() async {
    final result = await getSetting('allowed_domain_enabled');
    return result.map((value) => value?.toLowerCase() == 'true');
  }

  @override
  Future<Either<Failure, String?>> getAllowedDomain() async {
    return getSetting('allowed_domain');
  }
}
