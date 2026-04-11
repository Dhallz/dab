import 'package:dart_mappable/dart_mappable.dart';
import 'user_identity_status.dart';

part 'user_identity.mapper.dart';

@MappableClass()
class UserIdentity with UserIdentityMappable {
  final String id;
  final String userId;
  final String providerId;
  final String externalId;
  final UserIdentityStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserIdentity({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.externalId,
    this.status = UserIdentityStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });
}
