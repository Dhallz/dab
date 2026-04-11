import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

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
