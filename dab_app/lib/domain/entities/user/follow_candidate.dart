import 'package:dart_mappable/dart_mappable.dart';

import '../../core/activity_follow_key.dart';

part 'follow_candidate.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Follow picker row from `GET /users/me/follows/candidates`.
/// CONTRACT: [kind] is `issue` or `gitBranch`. Git [objectKey] is
/// `owner/repo|branch`.
@MappableClass()
class FollowCandidate with FollowCandidateMappable {
  final String providerId;
  final String objectKey;
  final String title;
  final String? url;
  final String kind;

  const FollowCandidate({
    required this.providerId,
    required this.objectKey,
    required this.title,
    this.url,
    this.kind = 'issue',
  });

  factory FollowCandidate.fromMap(Map<String, dynamic> map) =>
      FollowCandidateMapper.fromMap(map);

  String get objectRef => followObjectRef(providerId, objectKey);
}
