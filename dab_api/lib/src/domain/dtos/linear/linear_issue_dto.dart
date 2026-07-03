import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'linear_issue_dto.mapper.dart';

final _linearIssueActivityUuid = const Uuid();

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Parsed Linear issue row (GraphQL API or webhook) for ingestion.
/// CONTRACT: [dabUserId] is resolved by the caller from linked `linear`
/// identities (assignee first, then creator); rows without an attributable
/// user are skipped at mapping time.
///
/// Mapped to [Activity] via [OnLinearIssueDto.toActivities].
@MappableClass()
class LinearIssueDto with LinearIssueDtoMappable {
  /// Human-readable issue key (`ENG-123`).
  final String identifier;

  /// Team key prefix (`ENG`).
  final String teamKey;

  final String title;

  /// Workflow state name (`In Progress`).
  final String statusName;

  /// Deep link (`https://linear.app/acme/issue/ENG-123/...`).
  final String url;

  final DateTime updatedAt;

  /// DAB user id when assignee/creator resolves to a linked Linear identity.
  final String? dabUserId;

  /// Display name resolved from the Linear payload (`John Doe`).
  final String? authorDisplayName;

  const LinearIssueDto({
    required this.identifier,
    required this.teamKey,
    required this.title,
    required this.statusName,
    required this.url,
    required this.updatedAt,
    this.dabUserId,
    this.authorDisplayName,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a hydrated [LinearIssueDto] into a normalized [Activity].
/// CONSTRAINTS: Pure logic; skips rows without attributable DAB users.
extension OnLinearIssueDto on LinearIssueDto {
  List<Activity> toActivities(List<User> users) {
    final ownerId = dabUserId?.trim();
    if (ownerId == null || ownerId.isEmpty) return const [];
    final owner = users.where((u) => u.id == ownerId).firstOrNull;
    if (owner == null) return const [];

    final key = identifier.trim();
    if (key.isEmpty) return const [];

    final headline = title.trim().isEmpty ? key : title.trim();
    final statusTrim = statusName.trim();
    final urlTrim = url.trim();

    final bodyParts = <String>[];
    if (statusTrim.isNotEmpty) bodyParts.add('Status: $statusTrim');
    if (urlTrim.isNotEmpty) bodyParts.add(urlTrim);

    final id = _linearIssueActivityUuid.v5(Namespace.url.value, 'linear|$key');
    return [
      Activity(
        id: id,
        userId: owner.id,
        provider: LinearIssueProvider(
          identifier: key,
          teamKey: teamKey.trim().isEmpty ? null : teamKey.trim(),
          statusName: statusTrim.isEmpty ? null : statusTrim,
        ),
        title: '[$key] $headline',
        content: bodyParts.join('\n\n'),
        url: urlTrim.isEmpty ? null : urlTrim,
        authorName: _authorLine(owner, authorDisplayName),
        authorAvatarUrl: owner.avatarUrl,
        commentCount: 0,
        createdAt: updatedAt.toUtc(),
      ),
    ];
  }
}

String _authorLine(User user, String? externalDisplayName) {
  final label = externalDisplayName?.trim();
  if (label == null || label.isEmpty) return user.name;
  return '${user.name} ($label)';
}
