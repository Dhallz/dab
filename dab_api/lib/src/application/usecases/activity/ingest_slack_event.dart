import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_provider.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests a Slack Events API callback into DAB live pipeline.
/// CONTRACT: Stores new Slack activities and propagates them via Redis + WS.
/// CONSTRAINTS: Read-only with Slack, deduped by Slack event id and activity id.
class IngestSlackEvent {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;
  final _uuid = const Uuid();

  IngestSlackEvent(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService,
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

    final reserved = await _redisService.reserveSlackEventId(eventId);
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
    final recipientUserIds = <String>{};
    final mentionedSlackIds = _extractSlackUserMentions(text);
    for (final mentionedSlackId in mentionedSlackIds) {
      final recipientIdentity = linkedIdentityBySlackId[mentionedSlackId];
      if (recipientIdentity != null) {
        recipientUserIds.add(recipientIdentity.userId);
      }
    }
    if (_containsBroadcastMention(text)) {
      recipientUserIds.addAll(linkedUserIds);
    }
    if (recipientUserIds.isEmpty) {
      return const Right(
        SlackEventIngestionResult.ignored('no_target_mentions'),
      );
    }

    var ingestedCount = 0;
    for (final recipientUserId in recipientUserIds) {
      final activityId = _uuid.v5(
        Namespace.url.value,
        'slack-${teamId ?? 'workspace'}-$channelId-$ts-$recipientUserId',
      );
      final activity = Activity(
        id: activityId,
        userId: recipientUserId,
        provider: SlackMessageProvider(
          workspaceId: teamId,
          channelId: channelId,
          threadTs: (threadTs ?? '').isEmpty ? null : threadTs,
          messageTs: ts,
        ),
        title: _buildTitle(channelId: channelId, text: text),
        content: text.isEmpty ? '(no message text)' : text,
        url: _buildSlackUrl(
          baseUrl: slackConfig.baseUrl,
          channelId: channelId,
          ts: ts,
          threadTs: threadTs,
        ),
        authorName: senderIdentity?.externalUsername ?? slackUserId,
        authorAvatarUrl: senderUser?.avatarUrl,
        createdAt: _parseSlackTs(ts) ?? DateTime.now().toUtc(),
      );

      final createResult = await _activityRepository.createActivity(activity);
      if (createResult.isLeft()) {
        final message = createResult
            .getLeft()
            .toNullable()!
            .message
            .toLowerCase();
        if (_isDuplicateViolation(message)) {
          continue;
        }
        return Left(createResult.getLeft().toNullable()!);
      }
      ingestedCount++;
      print(
        '[SLACK_PIPELINE] db_insert activity_id=${activity.id} user_id=${activity.userId} event_user=$slackUserId',
      );
      await _redisService.incrementVersion();
      await _redisService.fanOutActivity(activity);
      final broadcastPayload = activity.toMap();
      _presenceService.broadcastToUser(
        activity.userId,
        'ACTIVITY_RECEIVED',
        broadcastPayload,
      );
      print(
        '[SLACK_PIPELINE] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return const Right(
        SlackEventIngestionResult.ignored('duplicate_activity'),
      );
    }
    return const Right(SlackEventIngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }

  DateTime? _parseSlackTs(String ts) {
    final seconds = double.tryParse(ts);
    if (seconds == null) {
      return null;
    }
    final millis = (seconds * 1000).round();
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  String _buildTitle({required String channelId, required String text}) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return '[#$channelId] Slack message';
    }
    if (normalized.length <= 60) {
      return '[#$channelId] $normalized';
    }
    return '[#$channelId] ${normalized.substring(0, 59)}...';
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
}

class SlackEventIngestionResult {
  final bool ingested;
  final String reason;

  const SlackEventIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const SlackEventIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const SlackEventIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
