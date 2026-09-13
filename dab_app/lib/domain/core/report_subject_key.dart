import '../entities/activity/activity.dart';
import 'activity_follow_key.dart';

/// [ARCH: DOMAIN]
/// ROLE: Daily-report subject keys: provider + object + **occurrence**.
/// CONTRACT: Finer than Follow `owner/repo|branch`. Two activities of the same
/// commit / comment / message collapse; two commits on the same branch do not.

/// [ARCH: DOMAIN]
/// ROLE: Occurrence key used to merge live Directed with authored search.
extension OnActivityReportSubject on Activity {
  /// Stable report line identity for this activity.
  String get reportSubjectKey {
    final provider = this.provider;
    return switch (provider) {
      SlackMessageProvider(
        :final workspaceId,
        :final channelId,
        :final messageTs,
      ) =>
        _joined(['slack', workspaceId, channelId, messageTs]),
      DiscordMessageProvider(
        :final guildId,
        :final channelId,
        :final messageId,
      ) =>
        _joined(['discord', guildId, channelId, messageId]),
      FigmaFileProvider(:final fileKey, :final commentId) => _joined([
        'figma',
        fileKey,
        (commentId ?? '').trim().isEmpty ? 'touched' : commentId,
      ]),
      GitHubCommitProvider(:final repo) => gitReportSubjectKey(
        providerId: 'github',
        repo: repo,
        url: url,
        title: title,
        occurredAt: createdAt,
      ),
      GitLabCommitProvider(:final project) => gitReportSubjectKey(
        providerId: 'gitlab',
        repo: project,
        url: url,
        title: title,
        occurredAt: createdAt,
      ),
      BitbucketCommitProvider(:final repo) => gitReportSubjectKey(
        providerId: 'bitbucket',
        repo: repo,
        url: url,
        title: title,
        occurredAt: createdAt,
      ),
      JiraIssueProvider() ||
      LinearIssueProvider() ||
      PhorgeTaskProvider() ||
      PhorgeRevisionProvider() ||
      GenericProvider() => _withoutRecipientAndFollow(id, userId),
    };
  }

  /// Ingest provider id for snapshots, or the generic name.
  String get reportProviderId {
    return provider.followProviderId ?? provider.name.trim().toLowerCase();
  }
}

/// Git occurrence key: commit sha from the URL when present, else title + time.
String gitReportSubjectKey({
  required String providerId,
  String? repo,
  String? url,
  required String title,
  required DateTime occurredAt,
}) {
  final repoKey = (repo ?? '').trim().toLowerCase();
  final sha = gitShaFromUrl(url);
  if (sha != null) {
    return '$providerId|$repoKey|$sha';
  }
  final ts = occurredAt.toUtc().millisecondsSinceEpoch ~/ 1000;
  return '$providerId|$repoKey|$ts|${title.trim().toLowerCase()}';
}

/// Parses a git commit sha from a provider URL (`…/commit/{sha}` or `…/commits/{sha}`).
String? gitShaFromUrl(String? url) {
  final raw = (url ?? '').trim();
  if (raw.isEmpty) return null;
  final match = RegExp(
    r'/(?:commits?|commit)/([0-9a-fA-F]{7,40})(?:[/?#]|$)',
  ).firstMatch(raw);
  final sha = match?.group(1)?.toLowerCase();
  if (sha == null || sha.isEmpty) return null;
  return sha;
}

String _joined(List<String?> parts) {
  return parts.map((part) => (part ?? '').trim()).join('|');
}

String _withoutRecipientAndFollow(String id, String userId) {
  var seed = id.trim();
  if (seed.endsWith('|follow')) {
    seed = seed.substring(0, seed.length - '|follow'.length);
  }
  final uid = userId.trim();
  if (uid.isNotEmpty && seed.endsWith('|$uid')) {
    seed = seed.substring(0, seed.length - uid.length - 1);
  }
  return seed;
}
