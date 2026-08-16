import '../../core/activity_follow_key.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Follow pin: this user wants every later update on [objectKey].
/// CONTRACT: [providerId] is an ingest id (`phorge`, `jira`, `linear`,
/// `slack`, `discord`). [objectKey] is the stable object identity from
/// [followObjectKeyFor]. Git is not represented.
class ActivityFollow {
  final String providerId;
  final String objectKey;

  const ActivityFollow({
    required this.providerId,
    required this.objectKey,
  });

  factory ActivityFollow.fromMap(Map<String, dynamic> map) {
    return ActivityFollow(
      providerId: (map['providerId'] ?? '').toString().trim(),
      objectKey: (map['objectKey'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toMap() => {
    'providerId': providerId,
    'objectKey': objectKey,
  };

  String get objectRef => followObjectRef(providerId, objectKey);
}
