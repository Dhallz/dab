import 'package:dart_mappable/dart_mappable.dart';

import 'group_type.dart';
import '../user/user.dart';

part 'group.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Represents a collection of users (Team, Project, or Circle).
/// CONTRACT: Used for activity filtering and access control.
/// CONSTRAINTS: Must define membership via internal [User] entities.
@MappableClass()
class Group with GroupMappable {
  /// Unique identifier (UUID).
  final String id;

  /// Display name of the group.
  final String name;

  /// Whether the group is manually managed or platform-synced.
  final GroupType type;

  /// The list of users belonging to this group.
  final List<User> members;

  /// Optional URL to a group representation icon.
  final String? iconUrl;

  /// If [type] is provider, the system name (e.g., 'slack', 'jira').
  final String? providerName;

  const Group({
    required this.id,
    required this.name,
    required this.type,
    this.members = const [],
    this.iconUrl,
    this.providerName,
  });
}
