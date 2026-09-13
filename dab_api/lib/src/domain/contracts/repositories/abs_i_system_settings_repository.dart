import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../core/org_calendar.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Abstract contract for storing and retrieving global system settings.
abstract interface class AbsISystemSettingsRepository {
  /// Retrieves a system setting by its unique key.
  Future<Either<Failure, String?>> getSetting(String key);

  /// Sets or updates a system setting.
  Future<Either<Failure, void>> setSetting(String key, String value);

  /// Helper to check whether domain validation is enabled (defaults to false).
  Future<Either<Failure, bool>> isDomainValidationEnabled();

  /// Helper to get the allowed email domain (if configured).
  Future<Either<Failure, String?>> getAllowedDomain();
}

/// Resolves the organization IANA timezone id from [system_timezone].
Future<String> loadOrgTimezoneId(AbsISystemSettingsRepository repo) async {
  final result = await repo.getSetting(kSystemTimezoneSettingKey);
  return result.fold(
    (_) => kDefaultOrgTimezoneId,
    (value) => resolveOrgTimezoneId(value),
  );
}
