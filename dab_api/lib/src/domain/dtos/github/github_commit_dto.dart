import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'github_commit_dto.mapper.dart';

final _gitHubCommitUuid = const Uuid();

@MappableClass()
class GitHubCommitDto with GitHubCommitDtoMappable {
  final String repo;
  final String? branch;
  final String sha;
  final String message;
  final String url;
  final String? authorLogin;
  final String? authorName;
  final String? authorEmail;
  final String? authorAvatarUrl;
  final DateTime committedAt;
  final String? userId;

  const GitHubCommitDto({
    required this.repo,
    required this.sha,
    required this.message,
    required this.url,
    required this.committedAt,
    this.branch,
    this.authorLogin,
    this.authorName,
    this.authorEmail,
    this.authorAvatarUrl,
    this.userId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Maps a [`GitHubCommitDto`] into persisted [`Activity`] rows (polling + webhook paths).
/// CONSTRAINTS: Pure logic; no I/O.
extension OnGitHubCommitDto on GitHubCommitDto {
  /// Resolves [`userId`] against [users] and returns at most one github-commit activity.
  List<Activity> toActivities(List<User> users) {
    final uid = userId;
    if (uid == null || uid.isEmpty) {
      return const [];
    }

    final user = users.where((u) => u.id == uid).firstOrNull;
    if (user == null) {
      return const [];
    }

    final (subject, body) = gitCommitSubjectAndBody;

    final branchTag = branch?.trim();
    final title = branchTag != null && branchTag.isNotEmpty
        ? '[$branchTag] $subject'
        : subject;

    final displayAuthorName = authorName?.trim().isNotEmpty == true ? authorName!.trim() : user.name;
    final login = authorLogin?.trim();
    final authorLine = login != null && login.isNotEmpty
        ? '$displayAuthorName (@$login)'
        : displayAuthorName;

    return [
      Activity(
        id: _gitHubCommitUuid.v5(Namespace.url.value, 'github-$repo-$sha'),
        userId: user.id,
        provider: GitHubCommitProvider(repo: repo, branch: branch),
        title: title,
        content: body,
        url: url,
        authorName: authorLine,
        authorAvatarUrl: authorAvatarUrl ?? user.avatarUrl,
        commentCount: 0,
        createdAt: committedAt,
      ),
    ];
  }

  /// [ARCH: DOMAIN]
  /// ROLE: Interpret multi-line Git commit messages as leading subject vs remainder (body).
  /// CONTRACT: CRLF normalized to LF, leading/trailing outer trim; absent body is `''`.
  (String, String) get gitCommitSubjectAndBody {
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
}
