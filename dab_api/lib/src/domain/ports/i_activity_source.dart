import 'package:dab_api/src/domain/entities/user/user.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Port for read-only ingestion of provider-native payloads into DAB.
/// CONTRACT: Implementations live in Infrastructure; return types are domain
/// [provider_payloads] rows that application maps to [`Activity`] via DTO extensions
/// (e.g. [`OnGitHubCommitDto.toActivities`]).
/// CONSTRAINTS: No business mapping rules here — fetch and shape only.

abstract interface class IActivitySource<T> {
  /// Fetches raw payloads for [users] in \[start, end\], scoped by [authoredOnly].
  Future<List<T>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  );
}
