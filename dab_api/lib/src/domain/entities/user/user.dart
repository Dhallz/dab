import 'package:dart_mappable/dart_mappable.dart';

import 'user_role.dart';

part 'user.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Central User model for internal authentication and identity management.
/// CONTRACT: Represents a human or system actor within DAB.
/// CONSTRAINTS: Must be serializable (Mappable). Used for JWT generation.
///
/// This entity bridges internal DAB security with external platform identities:
/// - Stores credentials ([passwordHash]) for internal login.
/// - Stores external PHIDs ([phorgePhid]) for activity mapping and synchronization.
@MappableClass()
class User with UserMappable {
  /// Unique internal identifier (UUID).
  final String id;

  /// Full display name of the user.
  final String name;

  /// Email address used for notifications and identification.
  final String email;

  /// Optional URL to the user's avatar.
  final String? avatarUrl;

  /// BCRYPT hash of the user's password.
  final String passwordHash;

  /// Access control role (e.g., 'Admin', 'Standard').
  final UserRole role;

  /// The unique identifier of this user in the Phorge system.
  final String? phorgePhid;

  /// The username registered in the Phorge system.
  final String? phorgeUsername;

  /// When the user account was first created in DAB.
  final DateTime createdAt;

  /// When the user's profile was last modified.
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    this.email = '',
    this.avatarUrl,
    this.passwordHash = '',
    this.role = UserRole.standard,
    this.phorgePhid,
    this.phorgeUsername,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
}
