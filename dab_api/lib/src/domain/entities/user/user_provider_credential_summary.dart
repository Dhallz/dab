import 'package:dart_mappable/dart_mappable.dart';

import 'user_provider_credential_status.dart';

part 'user_provider_credential_summary.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Masked credential status for `GET /users/me/credentials`.
/// CONTRACT: Never includes secret values.
@MappableClass()
class UserProviderCredentialSummary with UserProviderCredentialSummaryMappable {
  final String providerId;
  final UserProviderCredentialStatus status;
  final bool hasSecret;
  final bool isSharedBot;
  final String? externalId;
  final String? externalUsername;
  final DateTime? updatedAt;

  const UserProviderCredentialSummary({
    required this.providerId,
    required this.status,
    required this.hasSecret,
    this.isSharedBot = false,
    this.externalId,
    this.externalUsername,
    this.updatedAt,
  });
}
