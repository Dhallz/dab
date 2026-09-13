import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../postgres/app_database.dart';
import '../postgres/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of Platform Configuration retrieval in the API.
/// CONTRACT: Implements [AbsIProviderConfigRepository].
/// CONSTRAINTS: Directly queries [AppDatabase]. Performs Drift-to-Entity mapping.
class ProviderConfigRepository implements AbsIProviderConfigRepository {
  final AppDatabase _db;

  ProviderConfigRepository(this._db);

  @override
  Future<Either<Failure, List<ProviderConfig>>> getConfigs() async {
    try {
      final configs = await _db.select(_db.providerConfigsTable).get();
      return Right(configs.map<ProviderConfig>(_mapToEntity).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to fetch provider configs: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> countActiveConfigs() async {
    try {
      final query = _db.select(_db.providerConfigsTable)
        ..where((t) => t.isActive.equals(1));
      final configs = await query.get();
      return Right(configs.length);
    } catch (e) {
      return Left(DatabaseFailure('Failed to count active configs: $e'));
    }
  }

  @override
  Future<Either<Failure, ProviderConfig>> saveConfig(
    ProviderConfig config,
  ) async {
    try {
      await (_db
          .into(_db.providerConfigsTable)
          .insertOnConflictUpdate(
            ProviderConfigsTableCompanion(
              id: Value(config.id),
              name: Value(config.name),
              baseUrl: Value(config.baseUrl),
              isActive: Value(config.isActive ? 1 : 0),
              iconUrl: Value(config.iconUrl),
              settings: Value(jsonEncode(config.settings)),
              updatedAt: Value((DateTime.now()).toPgDateTime()),
            ),
          ));
      return Right(config);
    } catch (e) {
      return Left(DatabaseFailure('Failed to save provider config: $e'));
    }
  }

  ProviderConfig _mapToEntity(ProviderConfigsTableData record) {
    return ProviderConfig(
      id: record.id,
      name: record.name,
      baseUrl: record.baseUrl,
      isActive: record.isActive != 0,
      iconUrl: record.iconUrl,
      settings: jsonDecode(record.settings) as Map<String, dynamic>,
    );
  }
}
