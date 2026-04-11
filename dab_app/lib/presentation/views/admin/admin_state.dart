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
  final Map<String, ProviderConnectionStatus> connectionStatuses;
  final String? errorMessage;

  const AdminState({
    this.status = ViewStatus.initial,
    this.selectedSection = AdminSection.providers,
    this.configs = const [],
    this.identities = const [],
    this.users = const [],
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
