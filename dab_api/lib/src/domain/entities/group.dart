import 'package:dart_mappable/dart_mappable.dart';

import 'user.dart';

part 'group.mapper.dart';

@MappableEnum()
enum GroupType { custom, provider }

@MappableClass()
class Group with GroupMappable {
  final String id;
  final String name;
  final GroupType type;
  final List<User> members;
  final String? iconUrl;
  final String? providerName; // e.g., 'slack', 'jira'

  const Group({
    required this.id,
    required this.name,
    required this.type,
    this.members = const [],
    this.iconUrl,
    this.providerName,
  });
}
