import 'package:dart_mappable/dart_mappable.dart';

part 'activity_follow.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Follow pin: this user wants every later update on [objectKey].
/// CONTRACT: [providerId] is an ingest id (`phorge`, `jira`, `linear`,
/// `slack`, `discord`). [objectKey] is the stable object identity from
/// [followObjectKeyFor]. Git is not represented.
@MappableClass()
class ActivityFollow with ActivityFollowMappable {
  final String id;
  final String userId;
  final String providerId;
  final String objectKey;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ActivityFollow({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.objectKey,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toApiMap() => {
    'providerId': providerId,
    'objectKey': objectKey,
  };
}
