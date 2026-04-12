import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/domain/entities/user/user_identity_status.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import 'models/admin_island_bar_model.dart';
import 'models/admin_section.dart';
import 'models/provider_connection_status.dart';

part 'admin_state.mapper.dart';

enum IdentitySortField {
  fullName,
  provider,
  externalId,
  providerUsername,
  status,
}

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Admin Console screen state.
/// CONTRACT: Immutable Plain Old Data (POD) object.
@MappableClass()
class AdminState with AdminStateMappable {
  final ViewStatus status;
  final AdminSection selectedSection;
  final List<ProviderConfig> configs;
  final List<UserIdentity> identities;
  final List<User> users;
  final String identitySearchQuery;
  final IdentitySortField identitySortField;
  final bool identitySortAscending;
  final Map<String, ProviderConnectionStatus> connectionStatuses;
  final String? errorMessage;

  const AdminState({
    this.status = ViewStatus.initial,
    this.selectedSection = AdminSection.providers,
    this.configs = const [],
    this.identities = const [],
    this.users = const [],
    this.identitySearchQuery = '',
    this.identitySortField = IdentitySortField.fullName,
    this.identitySortAscending = true,
    this.connectionStatuses = const {},
    this.errorMessage,
  });

  factory AdminState.initial() => const AdminState();
}

/// [ARCH: PRESENTATION]
/// ROLE: View projections on [AdminState] (kept below the state class per extension rules).
extension OnAdminState on AdminState {
  /// Snapshot for [AdminIslandBarContent] tiles (providers, identities, users, connection health).
  AdminIslandBarModel get islandBarModel {
    final activeConfigs = configs.where((c) => c.isActive).toList();
    final health = _connectionHealthForActive(this, activeConfigs);
    return AdminIslandBarModel(
      activeProviders: activeConfigs.length,
      totalProviders: configs.length,
      unresolvedIdentities: identities
          .where((e) => e.status != UserIdentityStatus.linked)
          .length,
      usersCount: users.length,
      connectionOk: health.ok,
      connectionFailed: health.failed,
      connectionUnknown: health.unknown,
    );
  }

  List<UserIdentity> get filteredSortedIdentities {
    final lowerQuery = identitySearchQuery.trim().toLowerCase();
    final fullNameByUserId = {for (final user in users) user.id: user.name.trim()};

    final filtered = identities.where((identity) {
      if (lowerQuery.isEmpty) {
        return true;
      }
      final fullName = (fullNameByUserId[identity.userId] ?? identity.userId)
          .toLowerCase();
      final provider = identity.providerId.toLowerCase();
      final externalId = identity.externalId.toLowerCase();
      final userId = identity.userId.toLowerCase();
      final username = (identity.externalUsername ?? '').toLowerCase();
      return fullName.contains(lowerQuery) ||
          provider.contains(lowerQuery) ||
          externalId.contains(lowerQuery) ||
          userId.contains(lowerQuery) ||
          username.contains(lowerQuery);
    }).toList();

    filtered.sort((a, b) {
      final comparison = switch (identitySortField) {
        IdentitySortField.fullName => (fullNameByUserId[a.userId] ?? a.userId)
            .toLowerCase()
            .compareTo((fullNameByUserId[b.userId] ?? b.userId).toLowerCase()),
        IdentitySortField.provider => a.providerId.toLowerCase().compareTo(
          b.providerId.toLowerCase(),
        ),
        IdentitySortField.externalId => a.externalId.toLowerCase().compareTo(
          b.externalId.toLowerCase(),
        ),
        IdentitySortField.providerUsername => (a.externalUsername ?? '')
            .toLowerCase()
            .compareTo((b.externalUsername ?? '').toLowerCase()),
        IdentitySortField.status => a.status.name.compareTo(b.status.name),
      };
      return identitySortAscending ? comparison : -comparison;
    });

    return filtered;
  }
}

({int ok, int failed, int unknown}) _connectionHealthForActive(
  AdminState state,
  List<ProviderConfig> activeConfigs,
) {
  var ok = 0;
  var failed = 0;
  var unknown = 0;
  for (final c in activeConfigs) {
    final st = state.connectionStatuses[c.id]?.status ?? ViewStatus.initial;
    switch (st) {
      case ViewStatus.success:
        ok++;
        break;
      case ViewStatus.failure:
        failed++;
        break;
      default:
        unknown++;
        break;
    }
  }
  return (ok: ok, failed: failed, unknown: unknown);
}
