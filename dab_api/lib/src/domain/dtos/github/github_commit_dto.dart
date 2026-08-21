import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'github_commit_dto.mapper.dart';

final _gitHubCommitUuid = const Uuid();

/// [ARCH: DOMAIN]
/// ROLE: GitHub commit row mapped to [Activity] via [OnGitHubCommitDto].
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
  /// Resolves recipients against [users]. Explorer poll uses [userId]; live
  /// ingest passes [forUserIds] (Settings watchers) and [followerUserIds]
  /// (branch Follow pins).
  List<Activity> toActivities(
    List<User> users, {
    Iterable<String>? forUserIds,
    Iterable<String>? followerUserIds,
    String? senderUserId,
  }) {
    final usersById = {for (final u in users) u.id: u};
    final (subject, body) = gitCommitSubjectAndBody;
    final fanOut = forUserIds != null || followerUserIds != null;
    final targets = resolveInboxLaneTargets(
      forUserIds: forUserIds,
      followerUserIds: followerUserIds,
      fallbackUserId: userId,
    );
    if (targets.isEmpty) return const [];

    final activities = <Activity>[];
    for (final (targetId, lane) in targets) {
      final user = usersById[targetId];
      if (user == null) continue;
      final displayAuthorName = authorName?.trim().isNotEmpty == true
          ? authorName!.trim()
          : user.name;
      final login = authorLogin?.trim();
      final authorLine = login != null && login.isNotEmpty
          ? '$displayAuthorName (@$login)'
          : displayAuthorName;
      final stable = fanOut ? 'github-$repo-$sha-$targetId' : 'github-$repo-$sha';
      activities.add(
        Activity(
          id: _gitHubCommitUuid.v5(
            Namespace.url.value,
            stable.withInboxLaneId(lane),
          ),
          userId: user.id,
          senderUserId: senderUserId ?? userId,
          provider: GitHubCommitProvider(repo: repo, branch: branch),
          title: subject,
          content: body,
          url: url,
          authorName: authorLine,
          authorAvatarUrl: authorAvatarUrl ?? user.avatarUrl,
          commentCount: 0,
          createdAt: committedAt,
          inboxLane: lane,
        ),
      );
    }
    return activities;
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
