import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_provider_credential.dart';
import '../../../domain/entities/user/user_provider_credential_status.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';
import '../../core/security/settings_cipher.dart';
import '../postgres/app_database.dart';
import '../postgres/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persists per-user provider credentials with encrypted settings JSON.
class UserProviderCredentialRepository
    implements AbsIUserProviderCredentialRepository {
  UserProviderCredentialRepository(this._db, this._cipher);

  final AppDatabase _db;
  final SettingsCipher _cipher;

  @override
  Future<Either<Failure, UserProviderCredential?>> get({
    required String userId,
    required String providerId,
  }) async {
    try {
      final row =
          await (_db.select(_db.userProviderCredentialsTable)..where(
                (t) =>
                    t.userId.equals(userId) & t.providerId.equals(providerId),
              ))
              .getSingleOrNull();
      if (row == null) return const Right(null);
      return Right(_map(row));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load credential: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserProviderCredential>>> listForUser(
    String userId,
  ) async {
    try {
      final rows = await (_db.select(
        _db.userProviderCredentialsTable,
      )..where((t) => t.userId.equals(userId))).get();
      return Right(rows.map(_map).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to list credentials: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserProviderCredential>>> listForProvider(
    String providerId,
  ) async {
    try {
      final rows = await (_db.select(
        _db.userProviderCredentialsTable,
      )..where((t) => t.providerId.equals(providerId))).get();
      return Right(rows.map(_map).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to list provider credentials: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProviderCredential>> save(
    UserProviderCredential credential,
  ) async {
    try {
      final now = DateTime.now().toUtc();
      await _db
          .into(_db.userProviderCredentialsTable)
          .insertOnConflictUpdate(
            UserProviderCredentialsTableCompanion.insert(
              id: credential.id,
              userId: credential.userId,
              providerId: credential.providerId,
              settings: Value(_cipher.encryptMap(credential.settings)),
              status: Value(credential.status.name),
              createdAt: Value(credential.createdAt.toPgDateTime()),
              updatedAt: Value(now.toPgDateTime()),
            ),
          );
      return Right(credential.copyWith(updatedAt: now));
    } catch (e) {
      return Left(DatabaseFailure('Failed to save credential: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete({
    required String userId,
    required String providerId,
  }) async {
    try {
      await (_db.delete(_db.userProviderCredentialsTable)..where(
            (t) => t.userId.equals(userId) & t.providerId.equals(providerId),
          ))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete credential: $e'));
    }
  }

  UserProviderCredential _map(UserProviderCredentialsTableData row) {
    Map<String, dynamic> settings;
    try {
      settings = _cipher.decryptMap(row.settings);
    } catch (_) {
      final decoded = jsonDecode(row.settings);
      settings = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{};
    }
    return UserProviderCredential(
      id: row.id,
      userId: row.userId,
      providerId: row.providerId,
      settings: settings,
      status: UserProviderCredentialStatus.values.firstWhere(
        (e) => e.name == row.status,
        orElse: () => UserProviderCredentialStatus.connected,
      ),
      createdAt: row.createdAt.dateTime,
      updatedAt: row.updatedAt?.dateTime,
    );
  }
}
