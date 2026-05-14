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
/// [siteHost] disambiguates v5 IDs across tenants (e.g. `acme.atlassian.net`).
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
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a hydrated [JiraIssueDto] into a normalized [Activity].
/// CONSTRAINTS: Pure logic; skips rows without attributable DAB users.
extension OnJiraIssueDto on JiraIssueDto {
  List<Activity> toActivities(List<User> users) {
    final uid = dabUserId?.trim();
    if (uid == null || uid.isEmpty) return const [];

    final user = users.where((u) => u.id == uid).firstOrNull;
    if (user == null) return const [];

    final fingerprint = '${siteHost.trim().toLowerCase()}|$issueKey';
    final id = _jiraIssueActivityUuid.v5(Namespace.url.value, fingerprint);

    final headline = summary.trim().isEmpty ? issueKey : summary.trim();

    final authorLabel = authorDisplayName?.trim();
    final authorLine = authorLabel != null && authorLabel.isNotEmpty
        ? '${user.name} ($authorLabel)'
        : user.name;

    final statusTrim = statusName.trim();
    final bodyParts = <String>[];
    if (statusTrim.isNotEmpty) bodyParts.add('Status: $statusTrim');
    if (browseUrl.trim().isNotEmpty) bodyParts.add(browseUrl.trim());

    return [
      Activity(
        id: id,
        userId: user.id,
        provider: JiraIssueProvider(
          issueKey: issueKey,
          projectKey: projectKey,
          statusName: statusTrim.isEmpty ? null : statusTrim,
        ),
        title: '[$issueKey] $headline',
        content: bodyParts.join('\n\n'),
        url: browseUrl.trim().isEmpty ? null : browseUrl.trim(),
        authorName: authorLine,
        authorAvatarUrl: user.avatarUrl,
        commentCount: 0,
        createdAt: updatedAt.toUtc(),
      ),
    ];
  }
}
