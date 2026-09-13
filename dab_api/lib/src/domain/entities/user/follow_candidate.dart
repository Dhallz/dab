import 'package:dart_mappable/dart_mappable.dart';

part 'follow_candidate.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One object the caller can Follow from the Dashboard picker.
/// CONTRACT: [objectKey] matches [followObjectKeyFor] / git `repo|branch`.
/// [kind] is `issue` or `gitBranch`.
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

  Map<String, dynamic> toApiMap() => {
    'providerId': providerId,
    'objectKey': objectKey,
    'title': title,
    if (url != null && url!.isNotEmpty) 'url': url,
    'kind': kind,
  };
}
