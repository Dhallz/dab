import 'package:dart_mappable/dart_mappable.dart';

part 'user_identity.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Mapping between a DAB User and an external platform identity.
/// CONTRACT: Links a internal userId to an externalId for a specific provider.
@MappableClass()
class UserIdentity with UserIdentityMappable {
  final String id;
  final String userId;
  final String providerId;
  final String externalId;
  final String status; // Linked, Pending, Failed
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserIdentity({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.externalId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
}
