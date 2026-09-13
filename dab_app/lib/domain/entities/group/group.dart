import 'package:dart_mappable/dart_mappable.dart';
import 'group_type.dart';
import '../user/user.dart';

part 'group.mapper.dart';

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
