import 'package:uuid/uuid.dart';

import '../entities/activity/activity.dart';
import '../entities/activity/activity_provider.dart';
import '../entities/user/user.dart';

/// [ARCH: DOMAIN]
/// ROLE: Screenshot-quality demo [Activity] rows for every ingest provider.
/// CONTRACT: Same provider types and title shapes as live DTO mappers.
/// Ids are stable v5 hashes of `demo|{userId}|{date}|{kind}`.
/// [variant] shifts titles, keys, and provider mix so a team seed is not clones.
/// [dense] fills a Dashboard inbox (caller / solo); teammates stay sliced.

const _uuid = Uuid();

const _gitRepos = [
  'acme/app',
  'acme/api',
  'acme/web',
  'acme/mobile',
  'acme/infra',
  'acme/design',
  'acme/docs',
];
const _githubTitles = [
  'Fix session refresh on token expiry',
  'Retry inbox wakes after a socket drop',
  'Guard OAuth overlay against a stale token',
  'Trim live-feed copies on Follow unpin',
  'Parse org-calendar days in the search mapper',
  'Keep Vegas 304 in sync after archive',
  'Surface Follow pins on the live card',
  'Drop stale Redis copies at UTC midnight',
];
const _gitlabTitles = [
  'Tighten webhook HMAC checks',
  'Reject unsigned Push Hook deliveries',
  'Cap GitLab poll windows to the org day',
  'Map pipeline status onto the commit card',
  'Honor protected-branch Follow pins',
  'Skip fork pushes without a linked author',
];
const _bitbucketTitles = [
  'Restore offline inbox wakes',
  'Honor Bitbucket repo+branch Follow pins',
  'Skip fork pushes without a linked author',
  'Keep commit cards on the org-calendar day',
  'Fan out workspace webhook deliveries',
];
const _jiraSummaries = [
  'Fix login',
  'Ship schema',
  'Unlock reports',
  'Split inbox lanes',
  'Wire demo search',
  'Tighten live archive',
  'Sort Insights users',
];
const _linearSummaries = [
  'Ship schema',
  'Index follows',
  'Cache provider glyphs',
  'Sort Explorer groups',
  'Dense Dashboard seed',
  'Share directory groups',
];
const _phorgeSummaries = [
  'Fix login',
  'Herald mentions',
  'Revision landing',
  'Task board move',
  'Audit Follow pins',
  'Inbox lane split',
];
const _slackFollowLines = [
  'Shipping the inbox split this afternoon',
  'Demo seed is up if you want screenshots',
  'Lock chips landed on Reports',
  'Explorer grouping follows the directory now',
  'Dashboard needs more than a handful of cards',
  'Engineering standup is in the other thread',
];
const _slackMentions = [
  'can you take the login flake?',
  'the OAuth overlay is still stale after an hour',
  'can you review the inbox split before standup?',
  'Reports lock chips look right on desktop',
  'Insights is empty unless we pick the whole directory',
];
const _discordLines = [
  'Ship the new empty states',
  'Glyphs look off on mobile width',
  'Can we keep the 2:1 Dashboard split?',
  'Insights needs more than one author today',
  'Following pane is too quiet for a screenshot',
  'Directory groups should match Explorer',
];
const _figmaNotes = [
  'Can we match the Dashboard 2:1 split here?',
  'Locked chip should stay selected',
  'Directory picker needs a denser row',
  'Empty Insights state is too loud',
  'User tiles should not show Hasn\'t connected',
  'Feed needs more cards in Directed',
];
const _providerSlices = <Set<String>>[
  {'github', 'gitlab', 'jira', 'slack'},
  {'jira', 'linear', 'phorge', 'figma'},
  {'github', 'bitbucket', 'slack', 'discord'},
  {'gitlab', 'phorge', 'linear', 'slack'},
  {'figma', 'jira', 'discord', 'github'},
];

/// Builds directed, authored, and Follow-lane rows for [providerIds].
///
/// [createdAt] should already sit on the requested org-calendar day (and at
/// or after UTC midnight when the Dashboard live feed must show them).
/// [variant] picks titles and a provider slice; [teammates] supply real
/// [Activity.senderUserId] peers so Insights/Explorer are a graph.
/// [dense] skips the team slice and emits extra rows for a full inbox.
List<Activity> buildDemoDayActivities({
  required User user,
  required String date,
  required Set<String> providerIds,
  required DateTime createdAt,
  List<User> teammates = const [],
  int variant = 0,
  bool dense = false,
}) {
  final peer = _peer(user, teammates);
  final builders = <String, List<Activity> Function()>{
    'github': () => _github(user, date, createdAt, variant, peer, dense),
    'gitlab': () => _gitlab(user, date, createdAt, variant, peer, dense),
    'bitbucket': () => _bitbucket(user, date, createdAt, variant, peer, dense),
    'jira': () => _jira(user, date, createdAt, variant, peer, dense),
    'linear': () => _linear(user, date, createdAt, variant, peer, dense),
    'phorge': () => _phorge(user, date, createdAt, variant, peer, dense),
    'slack': () => _slack(user, date, createdAt, variant, peer, dense),
    'discord': () => _discord(user, date, createdAt, variant, peer, dense),
    'figma': () => _figma(user, date, createdAt, variant, peer, dense),
  };
  final catalogWanted = providerIds.isEmpty
      ? builders.keys.toSet()
      : providerIds.map((id) => id.trim().toLowerCase()).toSet();
  // Solo / dense Dashboard keeps every provider. Team mates stay sliced.
  var wanted = catalogWanted;
  if (!dense && teammates.length >= 2) {
    wanted = catalogWanted.intersection(
      _providerSlices[variant % _providerSlices.length],
    );
    if (wanted.isEmpty) wanted = catalogWanted;
  }
  final out = <Activity>[];
  var offset = 0;
  final stepMinutes = dense ? 4 : 7;
  for (final id in builders.keys) {
    if (!wanted.contains(id)) continue;
    for (final activity in builders[id]!()) {
      final stamped = createdAt.subtract(Duration(minutes: offset * stepMinutes));
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

User? _peer(User user, List<User> teammates) {
  if (teammates.length < 2) return null;
  final i = teammates.indexWhere((mate) => mate.id == user.id);
  final idx = i < 0 ? 0 : (i + 1) % teammates.length;
  final peer = teammates[idx];
  return peer.id == user.id ? null : peer;
}

String _pick(int variant, List<String> options) =>
    options[variant % options.length];

int _burst(bool dense) => dense ? 5 : 1;

List<Activity> _github(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final peerName = peer?.name ?? 'Maya Chen';
  final peerHandle = peer == null ? 'maya' : _handle(peer);
  final n = dense ? 5 : 1;
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final repo = _pick(variant + i, _gitRepos);
    const branch = 'main';
    final provider = GitHubCommitProvider(repo: repo, branch: branch);
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|github|commit|$i',
        user: user,
        provider: provider,
        title: _pick(variant + i, _githubTitles),
        content: 'Keep the Settings OAuth overlay valid after an hour.',
        url: 'https://github.com/$repo/commit/a1b2c3d$variant$i',
        authorName: '${user.name} (@${_handle(user)})',
        createdAt: at,
        senderUserId: user.id,
      ),
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|github|follow|$i',
        user: user,
        provider: provider,
        title: _pick(variant + i + 1, _githubTitles),
        content: 'Add Follow vs Directed notes to the README.',
        url: 'https://github.com/$repo/commit/b2c3d4e$variant$i',
        authorName: '$peerName (@$peerHandle)',
        createdAt: at,
        lane: ActivityInboxLane.follow,
        senderUserId: peer?.id,
      ),
    );
  }
  return out;
}

List<Activity> _gitlab(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = _burst(dense) + (dense ? 1 : 0);
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final project = _pick(variant + i + 1, _gitRepos);
    final provider = GitLabCommitProvider(project: project, branch: 'main');
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|gitlab|commit|$i',
        user: user,
        provider: provider,
        title: _pick(variant + i, _gitlabTitles),
        content: 'Reject unsigned GitLab Push Hook deliveries.',
        url: 'https://gitlab.com/$project/-/commit/c3d4e5f$variant$i',
        authorName: user.name,
        createdAt: at,
        senderUserId: user.id,
      ),
    );
    if (dense || i == 0) {
      out.add(
        _row(
          seed: 'demo|${user.id}|$date|gitlab|follow|$i',
          user: user,
          provider: provider,
          title: _pick(variant + i + 2, _gitlabTitles),
          content: 'Pipeline went green on the org-day window.',
          url: 'https://gitlab.com/$project/-/commit/c3d4e5f$variant${i}f',
          authorName: peer?.name ?? 'Maya Chen',
          createdAt: at,
          lane: ActivityInboxLane.follow,
          senderUserId: peer?.id,
        ),
      );
    }
  }
  return out;
}

List<Activity> _bitbucket(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = _burst(dense);
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final repo = _pick(variant + i + 2, _gitRepos);
    final provider = BitbucketCommitProvider(repo: repo, branch: 'main');
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|bitbucket|commit|$i',
        user: user,
        provider: provider,
        title: _pick(variant + i, _bitbucketTitles),
        content: 'Data-only FCM payload when the socket is down.',
        url: 'https://bitbucket.org/$repo/commits/d4e5f6a$variant$i',
        authorName: user.name,
        createdAt: at,
        senderUserId: user.id,
      ),
    );
    if (dense) {
      out.add(
        _row(
          seed: 'demo|${user.id}|$date|bitbucket|follow|$i',
          user: user,
          provider: provider,
          title: _pick(variant + i + 1, _bitbucketTitles),
          content: 'Branch Follow picked up the workspace push.',
          url: 'https://bitbucket.org/$repo/commits/d4e5f6a$variant${i}f',
          authorName: peer?.name ?? 'Maya Chen',
          createdAt: at,
          lane: ActivityInboxLane.follow,
          senderUserId: peer?.id,
        ),
      );
    }
  }
  return out;
}

List<Activity> _jira(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = dense ? 5 : 1;
  final peerName = peer?.name ?? 'Maya Chen';
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final key = 'DAB-${42 + variant + i}';
    final summary = _pick(variant + i, _jiraSummaries);
    final title = '[$key] $summary';
    final provider = JiraIssueProvider(
      issueKey: key,
      projectKey: 'DAB',
      statusName: 'In Progress',
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|jira|issue|$i',
        user: user,
        provider: provider,
        title: title,
        content: 'Status: In Progress',
        url: 'https://acme.atlassian.net/browse/$key',
        authorName: '${user.name} (${user.name})',
        createdAt: at,
        senderUserId: user.id,
      ),
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|jira|comment|$i',
        user: user,
        provider: provider,
        title: title,
        content: 'QA signed off on the $summary path.',
        url: 'https://acme.atlassian.net/browse/$key',
        authorName: '$peerName ($peerName)',
        createdAt: at,
        lane: ActivityInboxLane.follow,
        senderUserId: peer?.id,
        commentCount: 1,
      ),
    );
  }
  return out;
}

List<Activity> _linear(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = dense ? 5 : 1;
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final identifier = 'ENG-${18 + variant + i}';
    final summary = _pick(variant + i, _linearSummaries);
    final title = '[$identifier] $summary';
    final provider = LinearIssueProvider(
      identifier: identifier,
      teamKey: 'ENG',
      statusName: 'In Progress',
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|linear|issue|$i',
        user: user,
        provider: provider,
        title: title,
        content: 'Status: In Progress',
        url: 'https://linear.app/acme/issue/$identifier',
        authorName: user.name,
        createdAt: at,
        senderUserId: user.id,
      ),
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|linear|follow|$i',
        user: user,
        provider: provider,
        title: title,
        content: 'Moved estimate after the index review.',
        url: 'https://linear.app/acme/issue/$identifier',
        authorName: peer?.name ?? 'Maya Chen',
        createdAt: at,
        lane: ActivityInboxLane.follow,
        senderUserId: peer?.id,
        commentCount: 1,
      ),
    );
  }
  return out;
}

List<Activity> _phorge(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = dense ? 4 : 1;
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final taskN = 12 + variant + i;
    final summary = _pick(variant + i, _phorgeSummaries);
    final task = PhorgeTaskProvider(
      taskPhid: 'PHID-TASK-DEMO$taskN',
      tags: 'auth',
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|phorge|task|$i',
        user: user,
        provider: task,
        title: '[T$taskN] $summary',
        content: 'Moved task T$taskN from "Open" to "In Progress".',
        url: 'https://phorge.example.com/T$taskN',
        authorName: user.name,
        createdAt: at,
        senderUserId: user.id,
      ),
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|phorge|task-follow|$i',
        user: user,
        provider: task,
        title: '[T$taskN] $summary',
        content: 'Herald: mentioned you on the acceptance criteria.',
        url: 'https://phorge.example.com/T$taskN',
        authorName: peer?.name ?? 'Maya Chen',
        createdAt: at,
        lane: ActivityInboxLane.follow,
        senderUserId: peer?.id,
      ),
    );
    if (dense || i == 0) {
      final revision = PhorgeRevisionProvider(revisionId: '$taskN');
      out.add(
        _row(
          seed: 'demo|${user.id}|$date|phorge|revision|$i',
          user: user,
          provider: revision,
          title: 'D$taskN: $summary',
          content: 'Requested review on the session refresh path.',
          url: 'https://phorge.example.com/D$taskN',
          authorName: user.name,
          createdAt: at,
          senderUserId: user.id,
        ),
      );
    }
  }
  return out;
}

List<Activity> _slack(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final author = peer == null ? 'maya' : _handle(peer);
  final handle = _handle(user);
  final n = dense ? 5 : 1;
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final ts = '${100 + variant + i}.1';
    final provider = SlackMessageProvider(
      workspaceId: 'TDEMO',
      channelId: 'CENG',
      messageTs: ts,
      threadTs: ts,
    );
    final mention = i == 0
        ? '@$handle can you take the login flake?'
        : '@$handle ${_pick(variant + i, _slackMentions)}';
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|slack|mention|$i',
        user: user,
        provider: provider,
        title: '[#eng] $mention',
        content: mention,
        url: 'https://acme.slack.com/archives/CENG/p${100 + variant + i}1',
        authorName: author,
        createdAt: at,
        senderUserId: peer?.id,
      ),
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|slack|follow|$i',
        user: user,
        provider: provider,
        title: '[#eng] ${_pick(variant + i, _slackFollowLines)}',
        content: _pick(variant + i, _slackFollowLines),
        url: 'https://acme.slack.com/archives/CENG/p${100 + variant + i}1f',
        authorName: author,
        createdAt: at,
        lane: ActivityInboxLane.follow,
        senderUserId: peer?.id,
      ),
    );
  }
  return out;
}

List<Activity> _discord(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = dense ? 5 : 1;
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final provider = DiscordMessageProvider(
      guildId: '1',
      channelId: '2',
      messageId: '${3 + variant + i}',
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|discord|message|$i',
        user: user,
        provider: provider,
        title: '[#design] ${_pick(variant + i, _discordLines)}',
        content: _pick(variant + i, _discordLines),
        url: 'https://discord.com/channels/1/2/${3 + variant + i}',
        authorName: peer?.name ?? 'Maya Chen',
        createdAt: at,
        lane: i.isOdd ? ActivityInboxLane.follow : ActivityInboxLane.directed,
        senderUserId: peer?.id,
      ),
    );
  }
  return out;
}

List<Activity> _figma(
  User user,
  String date,
  DateTime at,
  int variant,
  User? peer,
  bool dense,
) {
  final n = dense ? 5 : 1;
  final touchedBy = peer?.name ?? 'Maya Chen';
  final out = <Activity>[];
  for (var i = 0; i < n; i++) {
    final fileKey = 'AbcDemoFile$variant$i';
    final comment = FigmaFileProvider(fileKey: fileKey, commentId: 'c$variant$i');
    final touched = FigmaFileProvider(fileKey: fileKey, lastTouchedBy: touchedBy);
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|figma|comment|$i',
        user: user,
        provider: comment,
        title: '[Design system] DAB',
        content: _pick(variant + i, _figmaNotes),
        url: 'https://www.figma.com/design/$fileKey/DAB',
        authorName: user.name,
        createdAt: at,
        senderUserId: user.id,
        commentCount: 1,
      ),
    );
    out.add(
      _row(
        seed: 'demo|${user.id}|$date|figma|touched|$i',
        user: user,
        provider: touched,
        title: '[Design system] DAB',
        content: 'last edited by $touchedBy',
        url: 'https://www.figma.com/design/$fileKey/DAB',
        authorName: touchedBy,
        createdAt: at,
        lane: ActivityInboxLane.follow,
        senderUserId: peer?.id,
      ),
    );
  }
  return out;
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
    createdAt: createdAt.toUtc(),
    inboxLane: lane,
    commentCount: commentCount,
  );
}

/// Screenshot @handle from the display name so a personal email local-part
/// (for example the operator's login) never lands on catalog cards.
String _handle(User user) {
  final fromName = _handleSlug(user.name);
  if (fromName.isNotEmpty) return fromName;
  final fromPhorge = user.phorgeUsername?.trim() ?? '';
  if (fromPhorge.isNotEmpty) {
    return fromPhorge.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
  }
  final email = user.email.trim();
  final at = email.indexOf('@');
  if (at > 0) return email.substring(0, at).toLowerCase();
  return 'you';
}

String _handleSlug(String name) {
  for (final part in name.trim().toLowerCase().split(RegExp(r'\s+'))) {
    final slug = part.replaceAll(RegExp('[^a-z0-9]'), '');
    if (slug.isNotEmpty) return slug;
  }
  return '';
}
