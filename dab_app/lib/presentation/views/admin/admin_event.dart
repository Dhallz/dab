import 'package:dart_mappable/dart_mappable.dart';
import 'package:dab_app/domain/entities/provider_config.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';

part 'admin_event.mapper.dart';

@MappableClass()
sealed class AdminEvent with AdminEventMappable {
  const AdminEvent();
}

@MappableClass()
class AdminStarted extends AdminEvent with AdminStartedMappable {
  const AdminStarted();
}

@MappableClass()
class AdminConfigUpdated extends AdminEvent with AdminConfigUpdatedMappable {
  final ProviderConfig config;
  const AdminConfigUpdated(this.config);
}

@MappableClass()
class AdminProviderToggled extends AdminEvent with AdminProviderToggledMappable {
  final String id;
  final bool isActive;
  const AdminProviderToggled({required this.id, required this.isActive});
}

@MappableClass()
class AdminSectionChanged extends AdminEvent with AdminSectionChangedMappable {
  final AdminSection section;
  const AdminSectionChanged(this.section);
}

@MappableClass()
class AdminUserRoleUpdated extends AdminEvent with AdminUserRoleUpdatedMappable {
  final String userId;
  final String role;
  const AdminUserRoleUpdated({required this.userId, required this.role});
}

@MappableClass()
class AdminIdentityLinked extends AdminEvent with AdminIdentityLinkedMappable {
  final String userId;
  final String providerId;
  final String externalId;
  const AdminIdentityLinked({
    required this.userId,
    required this.providerId,
    required this.externalId,
  });
}

@MappableClass()
class AdminTestConnection extends AdminEvent with AdminTestConnectionMappable {
  final ProviderConfig config;
  const AdminTestConnection(this.config);
}
