import 'package:dart_mappable/dart_mappable.dart';

part 'presence.mapper.dart';

@MappableClass()
class Presence with PresenceMappable {
  final String userId;
  final bool isOnline;
  final DateTime lastSeen;

  Presence({
    required this.userId,
    required this.isOnline,
    required this.lastSeen,
  });
}
