import 'package:dart_mappable/dart_mappable.dart';

import 'user_provider_credential_status.dart';

part 'user_provider_credential.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Per-user provider secrets used as fetch keys (never a visibility ACL).
/// CONTRACT: [settings] holds provider-native secret fields (same keys as Admin Core).
/// CONSTRAINTS: Must not be returned to other users; persist encrypted at rest.
@MappableClass()
class UserProviderCredential with UserProviderCredentialMappable {
  final String id;
  final String userId;
  final String providerId;
  final Map<String, dynamic> settings;
  final UserProviderCredentialStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProviderCredential({
    required this.id,
    required this.userId,
    required this.providerId,
    this.settings = const {},
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
}
