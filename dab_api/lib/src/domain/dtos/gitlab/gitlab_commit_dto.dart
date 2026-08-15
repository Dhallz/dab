import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'gitlab_commit_dto.mapper.dart';

final _gitLabCommitUuid = const Uuid();

/// [ARCH: DOMAIN]
/// ROLE: Parsed GitLab commit (REST API or Push Hook webhook) for ingestion.
/// CONTRACT: [userId] is resolved by the caller — GitLab commit rows carry no
/// platform user object, so attribution matches `author_email` against DAB
/// user emails and email-shaped linked `gitlab` identities.
///
/// Mapped to [Activity] via [OnGitLabCommitDto.toActivities].
@MappableClass()
class GitLabCommitDto with GitLabCommitDtoMappable {
  /// Full project path (`group/project`).
  final String project;

  final String? branch;
  final String sha;
  final String message;

  /// Web URL of the commit.
  final String url;

  final String? authorName;
  final String? authorEmail;
  final DateTime committedAt;

  /// DAB user id when the author resolves to a known user.
  final String? userId;

  const GitLabCommitDto({
    required this.project,
    required this.sha,
    required this.message,
    required this.url,
    required this.committedAt,
    this.branch,
    this.authorName,
    this.authorEmail,
    this.userId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a [`GitLabCommitDto`] into persisted [`Activity`] rows
/// (polling + webhook paths).
/// CONSTRAINTS: Pure logic; no I/O; skips rows without attributable users.
extension OnGitLabCommitDto on GitLabCommitDto {
  List<Activity> toActivities(List<User> users) {
    final uid = userId;
    if (uid == null || uid.isEmpty) {
      return const [];
    }

    final user = users.where((u) => u.id == uid).firstOrNull;
    if (user == null) {
      return const [];
    }

    final (subject, body) = _gitLabCommitSubjectAndBody(message);

    final branchTag = branch?.trim();
    final title = branchTag != null && branchTag.isNotEmpty
        ? '[$branchTag] $subject'
        : subject;

    final displayAuthorName = authorName?.trim().isNotEmpty == true
        ? authorName!.trim()
        : user.name;

    return [
      Activity(
        id: _gitLabCommitUuid.v5(Namespace.url.value, 'gitlab-$project-$sha'),
        userId: user.id,
        provider: GitLabCommitProvider(project: project, branch: branch),
        title: title,
        content: body,
        url: url,
        authorName: displayAuthorName,
        authorAvatarUrl: user.avatarUrl,
        commentCount: 0,
        createdAt: committedAt.toUtc(),
      ),
    ];
  }
}

(String, String) _gitLabCommitSubjectAndBody(String message) {
  final normalized = message.replaceAll('\r\n', '\n').trim();
  if (normalized.isEmpty) {
    return ('(empty commit message)', '');
  }
  final i = normalized.indexOf('\n');
  if (i < 0) {
    return (normalized, '');
  }
  final sub = normalized.substring(0, i).trim();
  final rest = normalized.substring(i + 1).trim();
  return (sub.isEmpty ? '(empty commit message)' : sub, rest);
}
