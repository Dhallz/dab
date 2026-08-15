import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'jira_issue_dto.mapper.dart';

final _jiraIssueActivityUuid = const Uuid();

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Parsed Jira Cloud issue search row for ingestion into DAB.
/// CONTRACT: [dabUserId] is resolved in [JiraIssueSource] from linked identities;
/// [siteHost] plus [updatedAt] disambiguate v5 IDs so a status move is a new
/// live event (Explorer search still returns the latest snapshot per issue).
///
/// Mapped to [Activity] via [OnJiraIssueDto.toActivities].
@MappableClass()
class JiraIssueDto with JiraIssueDtoMappable {
  final String issueKey;
  final String projectKey;
  final String summary;
  final String statusName;

  /// Deep link (`…/browse/PROJ-1`).
  final String browseUrl;
  final DateTime updatedAt;

  /// Normalized hostname from Jira Cloud site URL (`your-site.atlassian.net`).
  final String siteHost;

  /// DAB user id when assignee/reporter resolves to a linked Jira identity.
  final String? dabUserId;

  /// Display name resolved in source (`John Doe`).
  final String? authorDisplayName;

  /// Comment events attached to this issue for the queried window.
  final List<JiraIssueCommentDto> comments;

  /// When false (`comment_created` / `comment_updated` webhooks), only comment
  /// rows are emitted so Dashboard gets one ping. Issue owner still used as
  /// comment fallback.
  final bool includeIssueSnapshot;

  const JiraIssueDto({
    required this.issueKey,
    required this.projectKey,
    required this.summary,
    required this.statusName,
    required this.browseUrl,
    required this.updatedAt,
    required this.siteHost,
    this.dabUserId,
    this.authorDisplayName,
    this.comments = const [],
    this.includeIssueSnapshot = true,
  });
}

@MappableClass()
class JiraIssueCommentDto with JiraIssueCommentDtoMappable {
  final String id;
  final String body;
  final DateTime createdAt;
  final String? dabUserId;
  final String? authorDisplayName;

  const JiraIssueCommentDto({
    required this.id,
    required this.body,
    required this.createdAt,
    this.dabUserId,
    this.authorDisplayName,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a hydrated [JiraIssueDto] into a normalized [Activity].
/// CONSTRAINTS: Pure logic; skips rows without attributable DAB users.
extension OnJiraIssueDto on JiraIssueDto {
  List<Activity> toActivities(List<User> users) {
    final userById = {for (final u in users) u.id: u};
    final events = <Activity>[];

    final fingerprint =
        '${siteHost.trim().toLowerCase()}|$issueKey|${updatedAt.toUtc().millisecondsSinceEpoch}';
    final headline = summary.trim().isEmpty ? issueKey : summary.trim();
    final issueTitle = '[$issueKey] $headline';

    final statusTrim = statusName.trim();
    final issueOwnerId = dabUserId?.trim();
    final issueOwner = issueOwnerId == null || issueOwnerId.isEmpty
        ? null
        : userById[issueOwnerId];
    final fallbackUser = issueOwner;
    if (includeIssueSnapshot && issueOwner != null) {
      final id = _jiraIssueActivityUuid.v5(Namespace.url.value, fingerprint);
      final bodyParts = <String>[];
      if (statusTrim.isNotEmpty) bodyParts.add('Status: $statusTrim');
      if (browseUrl.trim().isNotEmpty) bodyParts.add(browseUrl.trim());
      events.add(
        Activity(
          id: id,
          userId: issueOwner.id,
          provider: JiraIssueProvider(
            issueKey: issueKey,
            projectKey: projectKey,
            statusName: statusTrim.isEmpty ? null : statusTrim,
          ),
          title: issueTitle,
          content: bodyParts.join('\n\n'),
          url: browseUrl.trim().isEmpty ? null : browseUrl.trim(),
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

      final cid = _jiraIssueActivityUuid.v5(
        Namespace.url.value,
        'jira|${siteHost.trim().toLowerCase()}|$issueKey|comment|${comment.id}',
      );
      final commentBody = comment.body.trim();
      events.add(
        Activity(
          id: cid,
          userId: commentUser.id,
          provider: JiraIssueProvider(
            issueKey: issueKey,
            projectKey: projectKey,
            statusName: statusTrim.isEmpty ? null : statusTrim,
          ),
          title: issueTitle,
          content: commentBody.isEmpty ? '(no comment body)' : commentBody,
          url: browseUrl.trim().isEmpty ? null : browseUrl.trim(),
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
