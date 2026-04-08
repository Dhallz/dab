import 'package:dart_mappable/dart_mappable.dart';
import 'package:dab_app/domain/entities/provider_config.dart';
import 'package:dab_app/domain/entities/user_identity.dart';
import 'package:dab_app/domain/entities/user.dart';

part 'admin_state.mapper.dart';

@MappableEnum()
enum AdminStatus { initial, loading, success, failure }

@MappableEnum()
enum AdminSection { providers, security, identities }

@MappableClass()
class ProviderConnectionStatus with ProviderConnectionStatusMappable {
  final AdminStatus status;
  final String? message;
  final DateTime? lastCheck;

  const ProviderConnectionStatus({
    this.status = AdminStatus.initial,
    this.message,
    this.lastCheck,
  });
}

@MappableClass()
class AdminState with AdminStateMappable {
  final AdminStatus status;
  final AdminSection selectedSection;
  final List<ProviderConfig> configs;
  final List<UserIdentity> identities;
  final List<User> users;
  final Map<String, ProviderConnectionStatus> connectionStatuses;
  final String? errorMessage;

  const AdminState({
    this.status = AdminStatus.initial,
    this.selectedSection = AdminSection.providers,
    this.configs = const [],
    this.identities = const [],
    this.users = const [],
    this.connectionStatuses = const {},
    this.errorMessage,
  });
}
