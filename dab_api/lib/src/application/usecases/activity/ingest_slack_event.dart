import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/live_inbox_targets.dart';
import '../../../domain/dtos/slack/slack_message_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/i_live_feed_store.dart';
import '../../../domain/contracts/ports/i_presence_broadcaster.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import '../../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../services/activity_live_publisher.dart';
import '../../services/live_ingest_persister.dart';
import 'inbox_followers.dart';
import 'ingestion_result.dart';

export 'ingestion_result.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests a Slack Events API callback into DAB live pipeline.
/// CONTRACT: Stores new Slack activities and propagates them via Redis + WS.
/// CONSTRAINTS: Read-only with Slack, deduped by Slack event id and activity id.
class IngestSlackEvent {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final ILiveFeedStore _liveFeed;
  final http.Client _httpClient;
  final LiveIngestPersister _persister;
  final AbsIActivityFollowRepository? _follows;

  IngestSlackEvent(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._liveFeed,
    IPresenceBroadcaster presence, {
    http.Client? httpClient,
    ActivityLivePublisher? livePublisher,
    LiveIngestPersister? persister,
    AbsIActivityFollowRepository? follows,
  }) : _httpClient = httpClient ?? http.Client(),
       _follows = follows,
       _persister =
           persister ??
           LiveIngestPersister(
             activities: activityRepository,
             liveFeed: _liveFeed,
             presence: presence,
             livePublisher: livePublisher,
           );

  Future<Either<Failure, SlackEventIngestionResult>> execute(
    Map<String, dynamic> payload,
  ) async {
    final callbackType = payload['type']?.toString() ?? '';
    if (callbackType != 'event_callback') {
      return const Right(
        SlackEventIngestionResult.ignored('not_event_callback'),
      );
    }

    final eventId = payload['event_id']?.toString() ?? '';
    if (eventId.isEmpty) {
      return const Right(SlackEventIngestionResult.ignored('missing_event_id'));
    }

    final reserved = await _liveFeed.reserveSlackEventId(eventId);
    if (!reserved) {
      return const Right(
        SlackEventIngestionResult.ignored('duplicate_event_id'),
      );
    }

    final event = payload['event'];
    if (event is! Map<String, dynamic>) {
      return const Right(
        SlackEventIngestionResult.ignored('invalid_event_payload'),
      );
    }

    final eventType = event['type']?.toString() ?? '';
    if (eventType != 'message') {
      return const Right(
        SlackEventIngestionResult.ignored('unsupported_event_type'),
      );
    }

    final subtype = event['subtype']?.toString();
    if (subtype != null && subtype.isNotEmpty) {
      return const Right(
        SlackEventIngestionResult.ignored('message_subtype_ignored'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final slackConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) => config.id.toLowerCase() == 'slack' && config.isActive,
        )
        .firstOrNull;
    if (slackConfig == null) {
      return const Right(
        SlackEventIngestionResult.ignored('slack_not_configured'),
      );
    }
    final settings = slackConfig.settings;

    final slackUserId = event['user']?.toString().trim() ?? '';
    final channelId = event['channel']?.toString().trim() ?? '';
    final ts = event['ts']?.toString().trim() ?? '';
    if (slackUserId.isEmpty || channelId.isEmpty || ts.isEmpty) {
      return const Right(
        SlackEventIngestionResult.ignored('missing_required_slack_fields'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(SlackEventIngestionResult.ignored('no_users_found'));
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(
          users.map((user) => user.id),
          'slack',
        );
    var identities = identitiesResult
        .getOrElse((_) => const [])
        .where((identity) => identity.status == UserIdentityStatus.linked)
        .toList();
    if (identities.isEmpty) {
      final allIdentitiesResult = await _userRepository.getAllIdentities();
      final allowedUserIds = users.map((user) => user.id).toSet();
      identities = allIdentitiesResult
          .getOrElse((_) => const [])
          .where((identity) => allowedUserIds.contains(identity.userId))
          .where((identity) => identity.status == UserIdentityStatus.linked)
          .where(
            (identity) => identity.providerId.trim().toLowerCase() == 'slack',
          )
          .toList();
    }
    final text = (event['text'] ?? '').toString().trim();
    final teamId = payload['team_id']?.toString().trim();
    final threadTs = event['thread_ts']?.toString().trim();
    final usersById = {for (final user in users) user.id: user};
    final linkedIdentityBySlackId = <String, UserIdentity>{};
    final linkedUserIds = <String>{};
    for (final identity in identities) {
      final normalizedId = _normalizeSlackExternalId(identity.externalId);
      linkedIdentityBySlackId[normalizedId] = identity;
      linkedUserIds.add(identity.userId);
    }
    if (linkedUserIds.isEmpty) {
      return const Right(
        SlackEventIngestionResult.ignored('no_linked_slack_identities'),
      );
    }

    final normalizedSlackUserId = _normalizeSlackExternalId(slackUserId);
    final senderIdentity = linkedIdentityBySlackId[normalizedSlackUserId];
    final senderUser = senderIdentity == null
        ? null
        : usersById[senderIdentity.userId];
    final token = _resolveToken(settings);
    final apiBaseUrl = _resolveApiBaseUrl(settings);
    final seededSlackUsernamesById = <String, String>{
      for (final identity in identities)
        if (_resolvedDisplayName(
          identity: identity,
          usersById: usersById,
        ).isNotEmpty)
          _normalizeSlackExternalId(identity.externalId): _resolvedDisplayName(
            identity: identity,
            usersById: usersById,
          ),
    };
    final usernamesBySlackId = await _resolveSlackUsernamesById(
      apiBaseUrl: apiBaseUrl,
      token: token,
      slackIds: {normalizedSlackUserId, ..._extractSlackUserMentions(text)},
      seeded: seededSlackUsernamesById,
    );
    final normalizedText = _normalizeMessageText(text, usernamesBySlackId);
    final channelLabel = await _resolveConversationLabel(
      apiBaseUrl: apiBaseUrl,
      token: token,
      channelId: channelId,
      usernamesBySlackId: usernamesBySlackId,
    );
    final senderDisplayName =
        (senderIdentity == null
            ? null
            : _resolvedDisplayName(
                identity: senderIdentity,
                usersById: usersById,
              )) ??
        usernamesBySlackId[normalizedSlackUserId] ??
        senderIdentity?.externalUsername?.trim() ??
        slackUserId;
    final senderUserId = senderIdentity?.userId;
    final recipientUserIds = <String>{};
    final mentionedSlackIds = _extractSlackUserMentions(text);
    recipientUserIds.addAll(
      liveInboxTargets(
        externalIds: mentionedSlackIds,
        externalToUser: {
          for (final entry in linkedIdentityBySlackId.entries)
            entry.key: entry.value.userId,
        },
      ),
    );
    if (_containsBroadcastMention(text)) {
      recipientUserIds.addAll(
        liveInboxBroadcastTargets(
          linkedUserIds: linkedUserIds,
          senderUserId: senderUserId,
        ),
      );
    }
    final slackFollowKey = slackFollowObjectKey(
      workspaceId: teamId,
      channelId: channelId,
      threadTs: threadTs,
      messageTs: ts,
    );
    final followers = slackFollowKey == null
        ? <String>{}
        : await inboxFollowerUserIds(
            _follows,
            providerId: 'slack',
            objectKeys: [slackFollowKey],
          );
    if (recipientUserIds.isEmpty && followers.isEmpty) {
      return const Right(
        SlackEventIngestionResult.ignored('no_target_mentions'),
      );
    }

    final dto = SlackMessageDto(
      channelId: channelId,
      channelLabel: channelLabel,
      workspaceId: teamId,
      text: normalizedText,
      userId: slackUserId,
      ts: ts,
      threadTs: (threadTs ?? '').isEmpty ? null : threadTs,
      permalink: _buildSlackUrl(
        baseUrl: slackConfig.baseUrl,
        channelId: channelId,
        ts: ts,
        threadTs: threadTs,
      ),
      userDisplayName: senderDisplayName,
      userAvatarUrl: senderUser?.avatarUrl,
      dabUserId: senderIdentity?.userId,
      createdAt: _parseSlackTs(ts) ?? DateTime.now().toUtc(),
    );
    return _persister.persist(
      activities: dto.toActivities(
        users,
        forUserIds: recipientUserIds,
        followerUserIds: followers,
        senderUserId: senderUserId,
      ),
      providerId: 'slack',
      emptyReason: 'duplicate_activity',
      logTag: 'SLACK_PIPELINE',
      onInserted: (activity) {
        print(
          '[SLACK_PIPELINE] db_insert activity_id=${activity.id} user_id=${activity.userId} event_user=$slackUserId',
        );
      },
    );
  }

  DateTime? _parseSlackTs(String ts) {
    final seconds = double.tryParse(ts);
    if (seconds == null) {
      return null;
    }
    final millis = (seconds * 1000).round();
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  String? _buildSlackUrl({
    required String baseUrl,
    required String channelId,
    required String ts,
    String? threadTs,
  }) {
    final normalizedBaseUrl = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    if (normalizedBaseUrl.isEmpty) {
      return null;
    }

    final tsValue = ts.replaceAll('.', '');
    final base = Uri.parse('$normalizedBaseUrl/archives/$channelId/p$tsValue');
    if ((threadTs ?? '').isEmpty) {
      return base.toString();
    }

    return base
        .replace(queryParameters: {'thread_ts': threadTs, 'cid': channelId})
        .toString();
  }

  String _normalizeSlackExternalId(String value) {
    var normalized = value.trim();
    if (normalized.startsWith('<@') && normalized.endsWith('>')) {
      normalized = normalized.substring(2, normalized.length - 1);
    }
    if (normalized.startsWith('@')) {
      normalized = normalized.substring(1);
    }
    return normalized.trim().toLowerCase();
  }

  Set<String> _extractSlackUserMentions(String text) {
    final matches = RegExp(r'<@([A-Za-z0-9]+)(?:\|[^>]+)?>').allMatches(text);
    return matches
        .map((match) => _normalizeSlackExternalId(match.group(1) ?? ''))
        .where((value) => value.isNotEmpty)
        .toSet();
  }

  bool _containsBroadcastMention(String text) {
    final lowered = text.toLowerCase();
    if (lowered.contains('<!channel>') ||
        lowered.contains('<!here>') ||
        lowered.contains('<!everyone>') ||
        lowered.contains('@all')) {
      return true;
    }
    return RegExp(r'<!subteam\^[A-Za-z0-9]+(?:\|[^>]+)?>').hasMatch(lowered);
  }

  String _normalizeMessageText(
    String text,
    Map<String, String> usernameBySlackId,
  ) {
    if (text.isEmpty) return text;
    var normalized = text;

    // User mentions: <@U123|alias> -> @DisplayName
    normalized = normalized.replaceAllMapped(
      RegExp(r'<@([A-Za-z0-9]+)(?:\|([^>]+))?>'),
      (match) {
        final rawId = match.group(1) ?? '';
        final slackId = _normalizeSlackExternalId(rawId);
        final username = usernameBySlackId[slackId]?.trim();
        final alias = (match.group(2) ?? '').trim();
        if (username != null && username.isNotEmpty) return '@$username';
        if (alias.isNotEmpty) return alias.startsWith('@') ? alias : '@$alias';
        return '@$rawId';
      },
    );

    // Channel mentions: <#C123|dev-backend> -> #dev-backend
    normalized = normalized.replaceAllMapped(
      RegExp(r'<#([A-Za-z0-9]+)\|([^>]+)>'),
      (match) {
        final label = (match.group(2) ?? '').trim();
        if (label.isEmpty) return '#${match.group(1) ?? ''}';
        return label.startsWith('#') ? label : '#$label';
      },
    );

    // User-group mentions: <!subteam^S123|@platform> -> @platform
    normalized = normalized.replaceAllMapped(
      RegExp(r'<!subteam\^[A-Za-z0-9]+(?:\|([^>]+))?>'),
      (match) {
        final label = (match.group(1) ?? '').trim();
        if (label.isEmpty) return '@team';
        return label.startsWith('@') ? label : '@$label';
      },
    );

    // Broadcast mentions in human-readable form.
    normalized = normalized
        .replaceAll('<!here>', '@here')
        .replaceAll('<!channel>', '@channel')
        .replaceAll('<!everyone>', '@everyone');

    return normalized;
  }

  Future<Map<String, String>> _resolveSlackUsernamesById({
    required String apiBaseUrl,
    required String token,
    required Set<String> slackIds,
    required Map<String, String> seeded,
  }) async {
    final result = Map<String, String>.from(seeded);
    if (token.isEmpty || apiBaseUrl.isEmpty) {
      return result;
    }
    final unresolved = slackIds.where(
      (id) => id.isNotEmpty && !result.containsKey(id),
    );
    for (final slackId in unresolved.take(30)) {
      final username = await _fetchSlackUsernameById(
        apiBaseUrl: apiBaseUrl,
        token: token,
        slackId: slackId,
      );
      if (username != null && username.isNotEmpty) {
        result[slackId] = username;
      }
    }
    return result;
  }

  Future<String?> _fetchSlackUsernameById({
    required String apiBaseUrl,
    required String token,
    required String slackId,
  }) async {
    try {
      final uri = Uri.parse(
        '$apiBaseUrl/users.info',
      ).replace(queryParameters: {'user': slackId});
      final response = await _httpClient
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=utf-8',
            },
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> || decoded['ok'] != true) {
        return null;
      }
      final user = decoded['user'] as Map<String, dynamic>?;
      final profile = user?['profile'] as Map<String, dynamic>?;
      final displayName = profile?['display_name']?.toString().trim();
      if (displayName != null && displayName.isNotEmpty) {
        return displayName;
      }
      final realName = profile?['real_name']?.toString().trim();
      if (realName != null && realName.isNotEmpty) {
        return realName;
      }
      final username = user?['name']?.toString().trim();
      if (username != null && username.isNotEmpty) {
        return username;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String> _resolveConversationLabel({
    required String apiBaseUrl,
    required String token,
    required String channelId,
    required Map<String, String> usernamesBySlackId,
  }) async {
    if (token.isEmpty || apiBaseUrl.isEmpty) {
      return '#$channelId';
    }
    try {
      final uri = Uri.parse(
        '$apiBaseUrl/conversations.info',
      ).replace(queryParameters: {'channel': channelId});
      final response = await _httpClient
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=utf-8',
            },
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return '#$channelId';
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> || decoded['ok'] != true) {
        return '#$channelId';
      }
      final channel = decoded['channel'] as Map<String, dynamic>? ?? const {};
      final isIm = channel['is_im'] == true;
      if (isIm) {
        final dmWithId = _normalizeSlackExternalId(
          channel['user']?.toString().trim() ?? '',
        );
        if (dmWithId.isEmpty) return 'DM';
        final seeded = usernamesBySlackId[dmWithId]?.trim();
        if (seeded != null && seeded.isNotEmpty) {
          return 'DM @$seeded';
        }
        final dmUsername = await _fetchSlackUsernameById(
          apiBaseUrl: apiBaseUrl,
          token: token,
          slackId: dmWithId,
        );
        if (dmUsername != null && dmUsername.isNotEmpty) {
          return 'DM @$dmUsername';
        }
        return 'DM @$dmWithId';
      }
      final name = channel['name']?.toString().trim();
      if (name != null && name.isNotEmpty) {
        return '#$name';
      }
      return '#$channelId';
    } catch (_) {
      return '#$channelId';
    }
  }

  String _resolveToken(Map<String, dynamic> settings) {
    return (settings['botToken'] ?? settings['accessToken'] ?? '')
        .toString()
        .trim();
  }

  String _resolveApiBaseUrl(Map<String, dynamic> settings) {
    final configured = (settings['apiBaseUrl'] ?? '').toString().trim();
    return (configured.isEmpty ? 'https://slack.com/api' : configured)
        .replaceAll(RegExp(r'/+$'), '');
  }

  String _resolvedDisplayName({
    required UserIdentity identity,
    required Map<String, User> usersById,
  }) {
    final userName = usersById[identity.userId]?.name.trim();
    if (userName != null && userName.isNotEmpty) return userName;
    final external = (identity.externalUsername ?? '').trim();
    if (external.isNotEmpty) return external;
    return '';
  }
}
