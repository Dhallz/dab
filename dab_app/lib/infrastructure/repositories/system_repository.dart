import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/system/app_settings.dart';
import '../../domain/repositories/abs_i_system_repository.dart';
import '../core/local/records/app_settings_record.dart';
import '../datasources/system_local_data_source.dart';
import 'core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of local System configuration and state management.
/// CONTRACT: Implements [ISystemRepository].
/// CONSTRAINTS: Purely for local persistence. Orchestrates [SystemLocalDataSource].
class SystemRepository extends Repository implements ISystemRepository {
  final SystemLocalDataSource _localDataSource;

  SystemRepository(this._localDataSource);

  @override
  Future<Either<AppFailure, AppSettings>> getSettings() {
    return guardedCall(() async {
      final record = await _localDataSource.getSettings();
      if (record == null) return const AppSettings();
      return record.toDomain;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> saveSettings(AppSettings settings) {
    return guardedCall(() async {
      await _localDataSource.saveSettings(
        AppSettingsRecord(
          themeMode: settings.appThemeVariant.name,
          localeCode: settings.localeCode,
          islandBarSelectionsJson: jsonEncode(settings.islandBarSelections),
          syncToken: settings.syncToken,
          inboxNotificationsDisabled: !settings.inboxNotificationsEnabled,
        ),
      );
      return unit;
    });
  }
}
