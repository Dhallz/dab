import 'package:uuid/uuid.dart';

import '../entities/activity/activity.dart';
import '../entities/activity/activity_provider.dart';
import '../entities/user/user.dart';

/// [ARCH: DOMAIN]
/// ROLE: Screenshot-quality demo [Activity] rows for every ingest provider.
/// CONTRACT: Same provider types and title shapes as live DTO mappers.
/// Ids are stable v5 hashes of `demo|{userId}|{date}|{kind}`.

const _uuid = Uuid();

/// Builds directed, authored, and Follow-lane rows for [providerIds].
///
/// [createdAt] should already sit on the requested org-calendar day (and at
/// or after UTC midnight when the Dashboard live feed must show them).
List<Activity> buildDemoDayActivities({
  required User user,
  required String date,
  required Set<String> providerIds,
  required DateTime createdAt,
}) {
  final builders = <String, List<Activity> Function()>{
    'github': () => _github(user, date, createdAt),
    'gitlab': () => _gitlab(user, date, createdAt),
    'bitbucket': () => _bitbucket(user, date, createdAt),
    'jira': () => _jira(user, date, createdAt),
    'linear': () => _linear(user, date, createdAt),
    'phorge': () => _phorge(user, date, createdAt),
    'slack': () => _slack(user, date, createdAt),
    'discord': () => _discord(user, date, createdAt),
    'figma': () => _figma(user, date, createdAt),
  };
  final wanted = providerIds.isEmpty
      ? builders.keys.toSet()
      : providerIds.map((id) => id.trim().toLowerCase()).toSet();
  final out = <Activity>[];
  var offset = 0;
  for (final id in builders.keys) {
    if (!wanted.contains(id)) continue;
    for (final activity in builders[id]!()) {
      final stamped = createdAt.subtract(Duration(minutes: offset * 7));
      final utc = createdAt.toUtc();
      final dayStart = DateTime.utc(utc.year, utc.month, utc.day);
      final created = stamped.isBefore(dayStart)
          ? dayStart.add(Duration(seconds: offset))
          : stamped;
      out.add(activity.copyWith(createdAt: created));
      offset++;
    }
  }
  return out;
}

List<Activity> _github(User user, String date, DateTime at) {
  const provider = GitHubCommitProvider(repo: 'acme/app', branch: 'main');
  return [
    _row(
      seed: 'demo|${user.id}|$date|github|commit',
      user: user,
      provider: provider,
      title: 'Fix session refresh on token expiry',
      content: 'Keep the Settings OAuth overlay valid after an hour.',
      url: 'https://github.com/acme/app/commit/a1b2c3d',
      authorName: '${user.name} (@${_handle(user)})',
      createdAt: at,
      senderUserId: user.id,
    ),
    _row(
      seed: 'demo|${user.id}|$date|github|follow',
      user: user,
      provider: provider,
      title: 'Document the inbox lane split',
      content: 'Add Follow vs Directed notes to the README.',
      url: 'https://github.com/acme/app/commit/b2c3d4e',
      authorName: 'Maya Chen (@maya)',
      createdAt: at,
      lane: ActivityInboxLane.follow,
    ),
  ];
}

List<Activity> _gitlab(User user, String date, DateTime at) {
  const provider = GitLabCommitProvider(project: 'acme/api', branch: 'main');
  return [
    _row(
      seed: 'demo|${user.id}|$date|gitlab|commit',
      user: user,
      provider: provider,
      title: 'Tighten webhook HMAC checks',
      content: 'Reject unsigned GitLab Push Hook deliveries.',
      url: 'https://gitlab.com/acme/api/-/commit/c3d4e5f',
      authorName: user.name,
      createdAt: at,
      senderUserId: user.id,
    ),
  ];
}

List<Activity> _bitbucket(User user, String date, DateTime at) {
  const provider = BitbucketCommitProvider(repo: 'acme/mobile', branch: 'main');
  return [
    _row(
      seed: 'demo|${user.id}|$date|bitbucket|commit',
      user: user,
      provider: provider,
      title: 'Restore offline inbox wakes',
      content: 'Data-only FCM payload when the socket is down.',
      url: 'https://bitbucket.org/acme/mobile/commits/d4e5f6a',
      authorName: user.name,
      createdAt: at,
      senderUserId: user.id,
    ),
  ];
}

List<Activity> _jira(User user, String date, DateTime at) {
  const provider = JiraIssueProvider(
    issueKey: 'DAB-42',
    projectKey: 'DAB',
    statusName: 'In Progress',
  );
  return [
    _row(
      seed: 'demo|${user.id}|$date|jira|issue',
      user: user,
      provider: provider,
      title: '[DAB-42] Fix login',
      content: 'Status: In Progress',
      url: 'https://acme.atlassian.net/browse/DAB-42',
      authorName: '${user.name} (${user.name})',
      createdAt: at,
      senderUserId: user.id,
    ),
    _row(
      seed: 'demo|${user.id}|$date|jira|comment',
      user: user,
      provider: provider,
      title: '[DAB-42] Fix login',
      content: 'QA signed off on the magic-link path.',
      url: 'https://acme.atlassian.net/browse/DAB-42',
      authorName: 'Maya Chen (Maya Chen)',
      createdAt: at,
      lane: ActivityInboxLane.follow,
      commentCount: 1,
    ),
  ];
}

List<Activity> _linear(User user, String date, DateTime at) {
  const provider = LinearIssueProvider(
    identifier: 'ENG-18',
    teamKey: 'ENG',
    statusName: 'In Progress',
  );
  return [
    _row(
      seed: 'demo|${user.id}|$date|linear|issue',
      user: user,
      provider: provider,
      title: '[ENG-18] Ship schema',
      content: 'Status: In Progress',
      url: 'https://linear.app/acme/issue/ENG-18',
      authorName: user.name,
      createdAt: at,
      senderUserId: user.id,
    ),
    _row(
      seed: 'demo|${user.id}|$date|linear|follow',
      user: user,
      provider: provider,
      title: '[ENG-18] Ship schema',
      content: 'Moved estimate to 3 after the index review.',
      url: 'https://linear.app/acme/issue/ENG-18',
      authorName: 'Maya Chen',
      createdAt: at,
      lane: ActivityInboxLane.follow,
      commentCount: 1,
    ),
  ];
}

List<Activity> _phorge(User user, String date, DateTime at) {
  const task = PhorgeTaskProvider(taskPhid: 'PHID-TASK-DEMO12', tags: 'auth');
  const revision = PhorgeRevisionProvider(revisionId: '12');
  return [
    _row(
      seed: 'demo|${user.id}|$date|phorge|task',
      user: user,
      provider: task,
      title: '[T12] Fix login',
      content: 'Moved task T12 from "Open" to "In Progress".',
      url: 'https://phorge.example.com/T12',
      authorName: user.name,
      createdAt: at,
      senderUserId: user.id,
    ),
    _row(
      seed: 'demo|${user.id}|$date|phorge|task-follow',
      user: user,
      provider: task,
      title: '[T12] Fix login',
      content: 'Herald: mentioned you on the acceptance criteria.',
      url: 'https://phorge.example.com/T12',
      authorName: 'Maya Chen',
      createdAt: at,
      lane: ActivityInboxLane.follow,
    ),
    _row(
      seed: 'demo|${user.id}|$date|phorge|revision',
      user: user,
      provider: revision,
      title: 'D12: Tighten auth',
      content: 'Requested review on the session refresh path.',
      url: 'https://phorge.example.com/D12',
      authorName: user.name,
      createdAt: at,
      senderUserId: user.id,
    ),
  ];
}

List<Activity> _slack(User user, String date, DateTime at) {
  const provider = SlackMessageProvider(
    workspaceId: 'TDEMO',
    channelId: 'CENG',
    messageTs: '100.1',
    threadTs: '100.1',
  );
  return [
    _row(
      seed: 'demo|${user.id}|$date|slack|mention',
      user: user,
      provider: provider,
      title: '[#eng] @${_handle(user)} can you take the login flake?',
      content: '@${_handle(user)} can you take the login flake?',
      url: 'https://acme.slack.com/archives/CENG/p1001',
      authorName: 'maya',
      createdAt: at,
    ),
    _row(
      seed: 'demo|${user.id}|$date|slack|follow',
      user: user,
      provider: provider,
      title: '[#eng] Shipping the inbox split this afternoon',
      content: 'Shipping the inbox split this afternoon.',
      url: 'https://acme.slack.com/archives/CENG/p1001',
      authorName: 'maya',
      createdAt: at,
      lane: ActivityInboxLane.follow,
    ),
  ];
}

List<Activity> _discord(User user, String date, DateTime at) {
  const provider = DiscordMessageProvider(
    guildId: '1',
    channelId: '2',
    messageId: '3',
  );
  return [
    _row(
      seed: 'demo|${user.id}|$date|discord|message',
      user: user,
      provider: provider,
      title: '[#design] Ship the new empty states',
      content: 'Ship the new empty states',
      url: 'https://discord.com/channels/1/2/3',
      authorName: 'Maya Chen',
      createdAt: at,
    ),
  ];
}

List<Activity> _figma(User user, String date, DateTime at) {
  const comment = FigmaFileProvider(fileKey: 'AbcDemoFileKey', commentId: 'c1');
  const touched = FigmaFileProvider(
    fileKey: 'AbcDemoFileKey',
    lastTouchedBy: 'Maya Chen',
  );
  return [
    _row(
      seed: 'demo|${user.id}|$date|figma|comment',
      user: user,
      provider: comment,
      title: '[Design system] DAB',
      content: 'Can we match the Dashboard 2:1 split here?',
      url: 'https://www.figma.com/design/AbcDemoFileKey/DAB',
      authorName: user.name,
      createdAt: at,
      senderUserId: user.id,
      commentCount: 1,
    ),
    _row(
      seed: 'demo|${user.id}|$date|figma|touched',
      user: user,
      provider: touched,
      title: '[Design system] DAB',
      content: 'last edited by Maya Chen',
      url: 'https://www.figma.com/design/AbcDemoFileKey/DAB',
      authorName: 'Maya Chen',
      createdAt: at,
      lane: ActivityInboxLane.follow,
    ),
  ];
}

Activity _row({
  required String seed,
  required User user,
  required ActivityProvider provider,
  required String title,
  required String content,
  required String url,
  required String authorName,
  required DateTime createdAt,
  ActivityInboxLane lane = ActivityInboxLane.directed,
  String? senderUserId,
  int commentCount = 0,
}) {
  return Activity(
    id: _uuid.v5(Namespace.url.value, seed.withInboxLaneId(lane)),
    userId: user.id,
    senderUserId: senderUserId,
    provider: provider,
    title: title,
    content: content,
    url: url,
    authorName: authorName,
    authorAvatarUrl: user.avatarUrl,
    commentCount: commentCount,
    createdAt: createdAt.toUtc(),
    inboxLane: lane,
  );
}

String _handle(User user) {
  final email = user.email.trim();
  final at = email.indexOf('@');
  if (at > 0) return email.substring(0, at);
  final name = user.name.trim().toLowerCase().replaceAll(' ', '');
  return name.isEmpty ? 'you' : name;
}
