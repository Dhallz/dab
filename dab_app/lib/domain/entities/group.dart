import 'package:dart_mappable/dart_mappable.dart';
import 'user.dart';

part 'group.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Organizational unit representing a collection of Users.
/// CONTRACT: Immutable Plain Old Data (POD) object.
/// CONSTRAINTS: Must be serializable via [GroupMappable]. 
@MappableEnum()
enum GroupType { custom, provider }

@MappableClass()
class Group with GroupMappable {
  final String id;
  final String name;
  final GroupType type;
  final List<User> members;
  final String? iconUrl;
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
