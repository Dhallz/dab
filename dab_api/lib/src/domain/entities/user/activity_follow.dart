import 'package:dart_mappable/dart_mappable.dart';

part 'activity_follow.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Follow pin: this user wants every later update on [objectKey].
/// CONTRACT: [providerId] is an ingest id (`phorge`, `jira`, `linear`,
/// `slack`, `discord`, `github`, `gitlab`, `bitbucket`). [objectKey] is the
/// stable object identity from [followObjectKeyFor] (git is `owner/repo|branch`).
/// [title] / [url] snapshot the Followed card so Dashboard can show a watching
/// row immediately.
@MappableClass()
class ActivityFollow with ActivityFollowMappable {
  final String id;
  final String userId;
  final String providerId;
  final String objectKey;
  final String? title;
  final String? url;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ActivityFollow({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.objectKey,
    this.title,
    this.url,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toApiMap() => {
    'providerId': providerId,
    'objectKey': objectKey,
    if (title != null && title!.isNotEmpty) 'title': title,
    if (url != null && url!.isNotEmpty) 'url': url,
  };
}
