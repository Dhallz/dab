import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'bitbucket_commit_dto.mapper.dart';

final _bitbucketCommitUuid = const Uuid();

/// [ARCH: DOMAIN]
/// ROLE: Parsed Bitbucket Cloud commit (REST 2.0 API or `repo:push` webhook)
/// for ingestion.
/// CONTRACT: [userId] is resolved by the caller — Bitbucket account ids from
/// linked `bitbucket` identities win, with commit author emails (parsed from
/// the `raw` signature) as fallback.
///
/// Mapped to [Activity] via [OnBitbucketCommitDto.toActivities].
@MappableClass()
class BitbucketCommitDto with BitbucketCommitDtoMappable {
  /// Full repository path (`workspace/repo`).
  final String repo;

  final String? branch;

  /// Commit hash.
  final String sha;

  final String message;

  /// Web URL of the commit.
  final String url;

  final String? authorName;
  final String? authorEmail;
  final DateTime committedAt;

  /// DAB user id when the author resolves to a known user.
  final String? userId;

  const BitbucketCommitDto({
    required this.repo,
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
/// ROLE: Maps a [`BitbucketCommitDto`] into persisted [`Activity`] rows
/// (polling + webhook paths).
/// CONSTRAINTS: Pure logic; no I/O; skips rows without attributable users.
extension OnBitbucketCommitDto on BitbucketCommitDto {
  List<Activity> toActivities(
    List<User> users, {
    Iterable<String>? forUserIds,
    Iterable<String>? followerUserIds,
    String? senderUserId,
  }) {
    final usersById = {for (final u in users) u.id: u};
    final (subject, body) = _bitbucketCommitSubjectAndBody(message);
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
      final stable = fanOut
          ? 'bitbucket-$repo-$sha-$targetId'
          : 'bitbucket-$repo-$sha';
      activities.add(
        Activity(
          id: _bitbucketCommitUuid.v5(
            Namespace.url.value,
            stable.withInboxLaneId(lane),
          ),
          userId: user.id,
          senderUserId: senderUserId ?? userId,
          provider: BitbucketCommitProvider(repo: repo, branch: branch),
          title: subject,
          content: body,
          url: url,
          authorName: displayAuthorName,
          authorAvatarUrl: user.avatarUrl,
          commentCount: 0,
          createdAt: committedAt.toUtc(),
          inboxLane: lane,
        ),
      );
    }
    return activities;
  }
}

(String, String) _bitbucketCommitSubjectAndBody(String message) {
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

/// Extracts the email from a raw Git signature (`Name <email>`).
String? bitbucketEmailFromRaw(String? raw) {
  if (raw == null) return null;
  final match = RegExp(r'<([^<>]+)>').firstMatch(raw);
  final email = match?.group(1)?.trim();
  if (email == null || email.isEmpty || !email.contains('@')) return null;
  return email;
}

/// Extracts the display name from a raw Git signature (`Name <email>`).
String? bitbucketNameFromRaw(String? raw) {
  if (raw == null) return null;
  final i = raw.indexOf('<');
  final name = (i < 0 ? raw : raw.substring(0, i)).trim();
  return name.isEmpty ? null : name;
}
