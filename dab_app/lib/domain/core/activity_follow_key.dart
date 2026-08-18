import '../entities/activity/activity_provider.dart';

/// [ARCH: DOMAIN]
/// ROLE: Stable Follow object keys shared by ingest and Dashboard.
/// CONTRACT: Generic providers return null. Git Follow is one repo + one
/// branch (`owner/repo|branch`); Settings git watches stay Directed.

/// Ingest provider ids that support per-object Follow.
const kFollowableProviderIds = {
  'phorge',
  'jira',
  'linear',
  'slack',
  'discord',
  'github',
  'gitlab',
  'bitbucket',
};

/// Git hosts that pin a single repo + branch on Following.
const kGitFollowProviderIds = {'github', 'gitlab', 'bitbucket'};

/// Whether [providerId] can be stored on `activity_follows`.
bool isFollowableProviderId(String providerId) =>
    kFollowableProviderIds.contains(providerId.trim().toLowerCase());

/// Whether [providerId] uses `repo|branch` Follow keys.
bool isGitFollowProviderId(String providerId) =>
    kGitFollowProviderIds.contains(providerId.trim().toLowerCase());

/// Ingest provider id for [provider], or null when Follow does not apply.
String? followProviderIdFor(ActivityProvider provider) {
  return switch (provider) {
    PhorgeTaskProvider() || PhorgeRevisionProvider() => 'phorge',
    JiraIssueProvider() => 'jira',
    LinearIssueProvider() => 'linear',
    SlackMessageProvider() => 'slack',
    DiscordMessageProvider() => 'discord',
    GitHubCommitProvider() => 'github',
    GitLabCommitProvider() => 'gitlab',
    BitbucketCommitProvider() => 'bitbucket',
    GenericProvider() => null,
  };
}

/// Opaque object key stored on `activity_follows`, or null when un-followable.
String? followObjectKeyFor(ActivityProvider provider) {
  return switch (provider) {
    PhorgeTaskProvider(:final taskPhid) => _nonEmpty(taskPhid),
    PhorgeRevisionProvider(:final revisionId) => _nonEmpty(revisionId),
    JiraIssueProvider(:final issueKey) => _nonEmpty(issueKey),
    LinearIssueProvider(:final identifier) => _nonEmpty(identifier),
    SlackMessageProvider(
      :final workspaceId,
      :final channelId,
      :final threadTs,
      :final messageTs,
    ) =>
      slackFollowObjectKey(
        workspaceId: workspaceId,
        channelId: channelId ?? '',
        threadTs: threadTs,
        messageTs: messageTs,
      ),
    DiscordMessageProvider(
      :final guildId,
      :final channelId,
      :final messageId,
      :final replyToId,
    ) =>
      discordFollowObjectKey(
        guildId: guildId,
        channelId: channelId ?? '',
        messageId: (replyToId ?? '').trim().isNotEmpty ? replyToId : messageId,
      ),
    GitHubCommitProvider(:final repo, :final branch) => gitFollowObjectKey(
      repo,
      branch,
    ),
    GitLabCommitProvider(:final project, :final branch) => gitFollowObjectKey(
      project,
      branch,
    ),
    BitbucketCommitProvider(:final repo, :final branch) => gitFollowObjectKey(
      repo,
      branch,
    ),
    GenericProvider() => null,
  };
}

/// Slack thread key: workspace + channel + thread root ts.
String? slackFollowObjectKey({
  String? workspaceId,
  required String channelId,
  String? threadTs,
  String? messageTs,
}) {
  final ws = (workspaceId ?? '').trim();
  final ch = channelId.trim();
  final root = ((threadTs ?? '').trim().isNotEmpty ? threadTs : messageTs)
      ?.trim();
  if (ws.isEmpty || ch.isEmpty || root == null || root.isEmpty) return null;
  return '$ws|$ch|$root';
}

/// Discord conversation key: guild + channel + root message id.
String? discordFollowObjectKey({
  String? guildId,
  required String channelId,
  String? messageId,
}) {
  final guild = (guildId ?? '').trim();
  final ch = channelId.trim();
  final id = (messageId ?? '').trim();
  if (guild.isEmpty || ch.isEmpty || id.isEmpty) return null;
  return '$guild|$ch|$id';
}

/// Keys to look up when ingesting a Discord message (this message and parent).
List<String> discordFollowLookupKeys({
  String? guildId,
  required String channelId,
  required String messageId,
  String? replyToId,
}) {
  final keys = <String>{};
  final self = discordFollowObjectKey(
    guildId: guildId,
    channelId: channelId,
    messageId: messageId,
  );
  if (self != null) keys.add(self);
  final parentId = (replyToId ?? '').trim();
  if (parentId.isNotEmpty) {
    final parent = discordFollowObjectKey(
      guildId: guildId,
      channelId: channelId,
      messageId: parentId,
    );
    if (parent != null) keys.add(parent);
  }
  return keys.toList();
}

/// One git Follow pin: lowercase `owner/repo` plus the branch name.
String? gitFollowObjectKey(String? repo, String? branch) {
  final repoKey = (repo ?? '').trim().toLowerCase();
  var name = (branch ?? '').trim();
  const heads = 'refs/heads/';
  if (name.toLowerCase().startsWith(heads)) {
    name = name.substring(heads.length);
  }
  if (repoKey.isEmpty || name.isEmpty) return null;
  return '$repoKey|$name';
}

/// Parses a git Follow [objectKey] into repo + branch.
({String repo, String branch})? parseGitFollowObjectKey(String objectKey) {
  final key = gitFollowObjectKey(
    objectKey.contains('|')
        ? objectKey.substring(0, objectKey.indexOf('|'))
        : '',
    objectKey.contains('|')
        ? objectKey.substring(objectKey.indexOf('|') + 1)
        : '',
  );
  if (key == null) return null;
  final split = key.indexOf('|');
  return (repo: key.substring(0, split), branch: key.substring(split + 1));
}

/// Stable Dashboard state key: ingest provider id plus object key.
String followObjectRef(String providerId, String objectKey) =>
    '$providerId\u001f$objectKey';

/// Combined Follow ref for [provider], or null when un-followable.
String? followObjectRefFor(ActivityProvider provider) {
  final providerId = followProviderIdFor(provider);
  final objectKey = followObjectKeyFor(provider);
  if (providerId == null || objectKey == null) return null;
  return followObjectRef(providerId, objectKey);
}

/// Rebuilds a followable [ActivityProvider] from a stored pin key.
///
/// Round-trips [followObjectKeyFor] so Dashboard can unfollow a quiet
/// watching placeholder with the same bookmark as a live card.
ActivityProvider activityProviderForFollow({
  required String providerId,
  required String objectKey,
}) {
  final id = providerId.trim().toLowerCase();
  final git = parseGitFollowObjectKey(objectKey);
  return switch (id) {
    'phorge' => _phorgeProviderForFollow(objectKey),
    'jira' => JiraIssueProvider(issueKey: objectKey),
    'linear' => LinearIssueProvider(identifier: objectKey),
    'slack' => _slackProviderForFollow(objectKey),
    'discord' => _discordProviderForFollow(objectKey),
    'github' => GitHubCommitProvider(repo: git?.repo, branch: git?.branch),
    'gitlab' => GitLabCommitProvider(project: git?.repo, branch: git?.branch),
    'bitbucket' => BitbucketCommitProvider(
      repo: git?.repo,
      branch: git?.branch,
    ),
    _ => GenericProvider(name: providerId),
  };
}

ActivityProvider _phorgeProviderForFollow(String objectKey) {
  final key = objectKey.trim();
  final upper = key.toUpperCase();
  if (upper.startsWith('PHID-DREV') || RegExp(r'^D\d+$').hasMatch(key)) {
    return PhorgeRevisionProvider(revisionId: key);
  }
  return PhorgeTaskProvider(taskPhid: key);
}

SlackMessageProvider _slackProviderForFollow(String objectKey) {
  final parts = objectKey.split('|');
  final workspaceId = parts.isNotEmpty ? parts[0] : '';
  final channelId = parts.length > 1 ? parts[1] : '';
  final ts = parts.length > 2 ? parts.sublist(2).join('|') : '';
  return SlackMessageProvider(
    workspaceId: workspaceId,
    channelId: channelId,
    threadTs: ts,
    messageTs: ts,
  );
}

DiscordMessageProvider _discordProviderForFollow(String objectKey) {
  final parts = objectKey.split('|');
  final guildId = parts.isNotEmpty ? parts[0] : '';
  final channelId = parts.length > 1 ? parts[1] : '';
  final messageId = parts.length > 2 ? parts.sublist(2).join('|') : '';
  return DiscordMessageProvider(
    guildId: guildId,
    channelId: channelId,
    messageId: messageId,
  );
}

String? _nonEmpty(String? raw) {
  final value = (raw ?? '').trim();
  return value.isEmpty ? null : value;
}
