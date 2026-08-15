import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/contracts/ports/i_credential_resolver.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Loads per-user credentials and overlays secrets onto org settings.
class CredentialResolver implements ICredentialResolver {
  CredentialResolver(this._repo);

  final AbsIUserProviderCredentialRepository _repo;

  @override
  Future<Map<String, dynamic>?> getUserSettings({
    required String userId,
    required String providerId,
  }) async {
    final result = await _repo.get(userId: userId, providerId: providerId);
    return result.fold((_) => null, (row) => row?.settings);
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getUserSettingsForUsers({
    required Iterable<String> userIds,
    required String providerId,
  }) async {
    final wanted = userIds.toSet();
    if (wanted.isEmpty) return {};
    final result = await _repo.listForProvider(providerId);
    return result.fold((_) => {}, (rows) {
      final out = <String, Map<String, dynamic>>{};
      for (final row in rows) {
        if (!wanted.contains(row.userId)) continue;
        out[row.userId] = row.settings;
      }
      return out;
    });
  }

  @override
  Map<String, dynamic> overlay({
    required Map<String, dynamic> orgSettings,
    Map<String, dynamic>? userSettings,
  }) {
    return overlayProviderSecrets(
      orgSettings: orgSettings,
      userSettings: userSettings,
    );
  }
}
