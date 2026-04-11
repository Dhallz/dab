import 'package:dart_mappable/dart_mappable.dart';
import 'user_role.dart';

part 'user.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Representation of a User identity in the DAB Client.
/// CONTRACT: Immutable Plain Old Data (POD) object.
/// CONSTRAINTS: Must be serializable via [UserMappable]. 
@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.standard,
    this.avatarUrl,
  });
}

extension OnUser on User {
  // Add entity-specific getters or mappers here
}
