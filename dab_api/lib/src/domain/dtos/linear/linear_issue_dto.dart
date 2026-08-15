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
/// user are skipped at mapping time unless [comments] resolve. [updatedAt]
/// is part of the issue activity id so a status move is a new live event.
/// Explorer still groups by [LinearIssueProvider.identifier].
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

  /// Comment events attached to this issue for the queried window.
  final List<LinearIssueCommentDto> comments;

  /// When false (Linear `Comment` webhooks), only comment rows are emitted so
  /// Dashboard gets one ping. Issue owner still used as comment fallback.
  final bool includeIssueSnapshot;

  const LinearIssueDto({
    required this.identifier,
    required this.teamKey,
    required this.title,
    required this.statusName,
    required this.url,
    required this.updatedAt,
    this.dabUserId,
    this.authorDisplayName,
    this.comments = const [],
    this.includeIssueSnapshot = true,
  });
}

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: One Linear comment on an issue, for a distinct live/Explorer event.
@MappableClass()
class LinearIssueCommentDto with LinearIssueCommentDtoMappable {
  final String id;
  final String body;
  final DateTime createdAt;
  final String? dabUserId;
  final String? authorDisplayName;

  const LinearIssueCommentDto({
    required this.id,
    required this.body,
    required this.createdAt,
    this.dabUserId,
    this.authorDisplayName,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a hydrated [LinearIssueDto] into normalized [Activity] rows.
/// CONSTRAINTS: Pure logic; skips rows without attributable DAB users.
/// Issue snapshots and comments are separate rows (unique ids) that share
/// [LinearIssueProvider.identifier] so Explorer stacks them like Phorge.
extension OnLinearIssueDto on LinearIssueDto {
  List<Activity> toActivities(List<User> users) {
    final userById = {for (final u in users) u.id: u};
    final events = <Activity>[];

    final key = identifier.trim();
    if (key.isEmpty) return const [];

    final headline = title.trim().isEmpty ? key : title.trim();
    final issueTitle = '[$key] $headline';
    final statusTrim = statusName.trim();
    final urlTrim = url.trim();
    final fingerprint = '$key|${updatedAt.toUtc().millisecondsSinceEpoch}';

    final issueOwnerId = dabUserId?.trim();
    final issueOwner = issueOwnerId == null || issueOwnerId.isEmpty
        ? null
        : userById[issueOwnerId];
    final fallbackUser = issueOwner;

    if (includeIssueSnapshot && issueOwner != null) {
      final bodyParts = <String>[];
      if (statusTrim.isNotEmpty) bodyParts.add('Status: $statusTrim');
      if (urlTrim.isNotEmpty) bodyParts.add(urlTrim);
      final id = _linearIssueActivityUuid.v5(
        Namespace.url.value,
        'linear|$fingerprint',
      );
      events.add(
        Activity(
          id: id,
          userId: issueOwner.id,
          provider: LinearIssueProvider(
            identifier: key,
            teamKey: teamKey.trim().isEmpty ? null : teamKey.trim(),
            statusName: statusTrim.isEmpty ? null : statusTrim,
          ),
          title: issueTitle,
          content: bodyParts.join('\n\n'),
          url: urlTrim.isEmpty ? null : urlTrim,
          authorName: _authorLine(issueOwner, authorDisplayName),
          authorAvatarUrl: issueOwner.avatarUrl,
          commentCount: 0,
          createdAt: updatedAt.toUtc(),
        ),
      );
    }

    for (final comment in comments) {
      final commentUserId = comment.dabUserId?.trim();
      final mappedCommentUser = commentUserId == null || commentUserId.isEmpty
          ? null
          : userById[commentUserId];
      final commentUser = mappedCommentUser ?? fallbackUser;
      if (commentUser == null) continue;

      final cid = _linearIssueActivityUuid.v5(
        Namespace.url.value,
        'linear|$key|comment|${comment.id}',
      );
      final commentBody = comment.body.trim();
      events.add(
        Activity(
          id: cid,
          userId: commentUser.id,
          provider: LinearIssueProvider(
            identifier: key,
            teamKey: teamKey.trim().isEmpty ? null : teamKey.trim(),
            statusName: statusTrim.isEmpty ? null : statusTrim,
          ),
          title: issueTitle,
          content: commentBody.isEmpty ? '(no comment body)' : commentBody,
          url: urlTrim.isEmpty ? null : urlTrim,
          authorName: _authorLine(commentUser, comment.authorDisplayName),
          authorAvatarUrl: commentUser.avatarUrl,
          commentCount: 1,
          createdAt: comment.createdAt.toUtc(),
        ),
      );
    }

    events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return events;
  }
}

String _authorLine(User user, String? externalDisplayName) {
  final label = externalDisplayName?.trim();
  if (label == null || label.isEmpty) return user.name;
  return '${user.name} ($label)';
}
