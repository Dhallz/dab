import 'package:uuid/uuid.dart';

import '../../domain/entities/user/user.dart';
import '../../domain/entities/user/user_identity.dart';
import '../../domain/entities/user/user_identity_status.dart';
import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../domain/repositories/abs_i_user_repository.dart';
import '../../domain/ports/i_discovery_source.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Orchestrator for automated identity resolution across providers.
/// CONTRACT: Discovers potential identity matches for DAB users using external sources.
/// CONSTRAINTS: Only performs lookups for [isActive] providers.
///              Creates identities with [UserIdentityStatus.pending].
class IdentityDiscoveryService {
  final IUserRepository _userRepo;
  final AbsIProviderConfigRepository _configRepo;
  final Map<String, IDiscoverySource> _discoverySources;
  final _uuid = const Uuid();

  IdentityDiscoveryService(
    this._userRepo,
    this._configRepo,
    this._discoverySources,
  );

  /// Performs an exhaustive discovery run for all DAB users.
  Future<void> runFullDiscovery() async {
    final usersResult = await _userRepo.getUsers();
    final users = usersResult.getOrElse((_) => []);

    for (final user in users) {
      await discoverForUser(user);
    }
  }

  /// Attempts to find matching identities for a single user across all active sources.
  Future<void> discoverForUser(User user) async {
    final configsResult = await _configRepo.getConfigs();
    final activeConfigs = configsResult.fold(
      (l) => <String, bool>{},
      (configs) => {for (var c in configs) c.id: c.isActive},
    );

    for (final entry in _discoverySources.entries) {
      final providerId = entry.key;
      final source = entry.value;

      // Skip if provider is deactivated or if the user already has a linked identity.
      if (!(activeConfigs[providerId] ?? false)) continue;

      final existingIdentity = await _userRepo.getIdentity(user.id, providerId);
      if (existingIdentity.fold((l) => false, (r) => r != null)) continue;

      // Trigger heuristic lookup
      final lookupResult = await source.lookupExternalId(user.name, user.email);

      await lookupResult.fold(
        (failure) async => print(
          'Discovery failed for ${user.email} on $providerId: $failure',
        ),
        (externalId) async {
          if (externalId != null) {
            final newIdentity = UserIdentity(
              id: _uuid.v4(),
              userId: user.id,
              providerId: providerId,
              externalId: externalId,
              status: UserIdentityStatus.pending,
              createdAt: DateTime.now(),
            );
            await _userRepo.linkIdentity(newIdentity);
            print(
              '🌱 Discovered candidate identity for ${user.email} on $providerId: $externalId',
            );
          }
        },
      );
    }
  }
}
