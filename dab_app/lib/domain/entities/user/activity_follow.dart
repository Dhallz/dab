import 'package:dart_mappable/dart_mappable.dart';

import '../../core/activity_follow_key.dart';

part 'activity_follow.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Follow pin: this user wants every later update on [objectKey].
/// CONTRACT: [providerId] is an ingest id (`phorge`, `jira`, `linear`,
/// `slack`, `discord`, `github`, `gitlab`, `bitbucket`). [objectKey] is the
/// stable object identity from [followObjectKeyFor] (git is `owner/repo|branch`).
/// [title] / [url] snapshot the Followed card so Dashboard can show a
/// placeholder in the Following feed until the first Follow-lane event.
/// Settings git watches stay Directed.
@MappableClass()
class ActivityFollow with ActivityFollowMappable {
  final String providerId;
  final String objectKey;
  final String? title;
  final String? url;

  const ActivityFollow({
    required this.providerId,
    required this.objectKey,
    this.title,
    this.url,
  });

  factory ActivityFollow.fromMap(Map<String, dynamic> map) =>
      ActivityFollowMapper.fromMap(map);

  String get objectRef => followObjectRef(providerId, objectKey);

  /// Title for a quiet Following placeholder; falls back to [objectKey].
  String get displayTitle {
    final value = title?.trim() ?? '';
    return value.isEmpty ? objectKey : value;
  }
}
