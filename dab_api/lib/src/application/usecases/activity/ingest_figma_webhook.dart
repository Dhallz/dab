import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/figma_scope.dart';
import '../../../domain/core/live_inbox_targets.dart';
import '../../../domain/dtos/figma/figma_file_dto.dart';
import '../../../domain/entities/figma/figma_file_meta.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/abs_i_figma_file_gateway.dart';
import '../../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../../domain/contracts/ports/abs_i_presence_broadcaster.dart';
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
/// ROLE: Ingests Figma webhooks (`FILE_COMMENT`, `FILE_UPDATE`, `PING`).
/// CONTRACT: `FILE_COMMENT` fans Directed mentions plus file Followers.
/// `FILE_UPDATE` wakes a last-edited Following heartbeat after meta GET.
/// `PING` is ignored here (controller ACKs). Read-only toward Figma.
class IngestFigmaWebhook {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final AbsILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;
  final AbsIActivityFollowRepository? _follows;
  final AbsIFigmaFileGateway? _fileGateway;

  IngestFigmaWebhook(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._liveFeed,
    AbsIPresenceBroadcaster presence, {
    ActivityLivePublisher? livePublisher,
    LiveIngestPersister? persister,
    AbsIActivityFollowRepository? follows,
    AbsIFigmaFileGateway? fileGateway,
  }) : _follows = follows,
       _fileGateway = fileGateway,
       _persister =
           persister ??
           LiveIngestPersister(
             activities: activityRepository,
             liveFeed: _liveFeed,
             presence: presence,
             livePublisher: livePublisher,
           );

  Future<Either<Failure, FigmaWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
  }) async {
    final event = _eventType(payload);
    if (event == 'PING' || event.isEmpty) {
      return Right(
        FigmaWebhookIngestionResult.ignored(
          event == 'PING' ? 'ping' : 'unsupported_event:$event',
        ),
      );
    }
    if (event != 'FILE_COMMENT' && event != 'FILE_UPDATE') {
      return Right(
        FigmaWebhookIngestionResult.ignored('unsupported_event:$event'),
      );
    }

    final fileKey = (payload['file_key'] ?? payload['fileKey'] ?? '')
        .toString()
        .trim();
    if (fileKey.isEmpty) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('missing_file_key'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final figmaConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'figma' && config.isActive,
        )
        .firstOrNull;
    if (figmaConfig == null) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('figma_not_configured'),
      );
    }

    final fileKeys = parseFigmaFileKeys(figmaConfig.settings['fileKeys']);
    final teamIds = parseFigmaTeamIds(
      figmaConfig.settings['teamIds'] ?? figmaConfig.settings['teamId'],
    );
    final teamId = (payload['team_id'] ?? payload['teamId'] ?? '')
        .toString()
        .trim();
    if (!figmaFileKeyAllowed(fileKey, fileKeys) ||
        !figmaTeamIdAllowed(teamId, teamIds)) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('file_not_allowed'),
      );
    }

    if (event == 'FILE_COMMENT') {
      return _ingestComment(payload: payload, fileKey: fileKey);
    }
    return _ingestFileUpdate(payload: payload, fileKey: fileKey);
  }

  Future<Either<Failure, FigmaWebhookIngestionResult>> _ingestComment({
    required Map<String, dynamic> payload,
    required String fileKey,
  }) async {
    final comment = _firstComment(payload);
    final commentId = (comment?['id'] ?? '').toString().trim();
    if (commentId.isEmpty) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('invalid_comment_payload'),
      );
    }

    final createdAt =
        _parseDateTime(comment?['created_at'] ?? comment?['createdAt']) ??
        _parseDateTime(payload['timestamp']) ??
        DateTime.now().toUtc();

    final fingerprint = 'FILE_COMMENT|$fileKey|$commentId';
    final reserved = await _liveFeed.reserveIngestionEventId(
      'figma',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(FigmaWebhookIngestionResult.ignored('no_users_found'));
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'figma');
    final figmaToUser = <String, String>{};
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final key = identity.externalId.trim();
      if (key.isEmpty) continue;
      figmaToUser.putIfAbsent(key, () => identity.userId);
    }

    final author = _triggeredBy(payload) ?? _userMap(comment?['user']);
    final authorId = (author?['id'] ?? '').toString().trim();
    final authorHandle = _handleOf(author);
    final senderUserId = authorId.isEmpty ? null : figmaToUser[authorId];

    final mentions = _mentionIds(comment);
    final directed = liveInboxTargets(
      externalIds: mentions,
      externalToUser: figmaToUser,
    );
    final followers = await inboxFollowerUserIds(
      _follows,
      providerId: 'figma',
      objectKeys: [fileKey],
    );
    if (directed.isEmpty && followers.isEmpty) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('no_target_mentions'),
      );
    }

    FigmaFileMeta? meta;
    try {
      meta = await _fileGateway?.fetchFileMeta(fileKey);
    } catch (_) {
      meta = null;
    }
    final fileName = _displayFileTitle(
      fileKey: fileKey,
      payload: payload,
      meta: meta,
    );
    final dto = FigmaFileDto(
      fileKey: fileKey,
      fileName: fileName,
      createdAt: createdAt,
      commentId: commentId,
      commentMessage: _commentMessage(comment),
      parentId: (comment?['parent_id'] ?? comment?['parentId'] ?? '')
          .toString()
          .trim(),
      authorId: authorId.isEmpty ? null : authorId,
      authorHandle: authorHandle,
      mentionIds: mentions,
      dabUserId: senderUserId,
    );
    final activities = dto.toActivities(
      users,
      forUserIds: directed,
      followerUserIds: followers,
      senderUserId: senderUserId,
    );
    if (activities.isEmpty) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('no_eligible_activities'),
      );
    }

    return _persister.persist(
      activities: activities,
      providerId: 'figma',
      emptyReason: 'duplicate_activity',
      logTag: 'FIGMA_WEBHOOK',
    );
  }

  Future<Either<Failure, FigmaWebhookIngestionResult>> _ingestFileUpdate({
    required Map<String, dynamic> payload,
    required String fileKey,
  }) async {
    final followers = await inboxFollowerUserIds(
      _follows,
      providerId: 'figma',
      objectKeys: [fileKey],
    );
    if (followers.isEmpty) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('no_file_followers'),
      );
    }

    final webhookAt =
        _parseDateTime(payload['timestamp']) ?? DateTime.now().toUtc();
    final fingerprint =
        'FILE_UPDATE|$fileKey|${webhookAt.millisecondsSinceEpoch}';
    final reserved = await _liveFeed.reserveIngestionEventId(
      'figma',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(FigmaWebhookIngestionResult.ignored('no_users_found'));
    }

    FigmaFileMeta? meta;
    try {
      meta = await _fileGateway?.fetchFileMeta(fileKey);
    } catch (_) {
      meta = null;
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'figma');
    final figmaToUser = <String, String>{};
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final key = identity.externalId.trim();
      if (key.isEmpty) continue;
      figmaToUser.putIfAbsent(key, () => identity.userId);
    }

    final handle = (meta?.lastTouchedByHandle ?? '').trim();
    final touchedId = (meta?.lastTouchedById ?? '').trim();
    final senderUserId = touchedId.isEmpty ? null : figmaToUser[touchedId];
    final fileName = _displayFileTitle(
      fileKey: fileKey,
      payload: payload,
      meta: meta,
    );
    final createdAt = meta?.lastTouchedAt ?? webhookAt;

    final dto = FigmaFileDto(
      fileKey: fileKey,
      fileName: fileName,
      createdAt: createdAt,
      authorId: touchedId.isEmpty ? null : touchedId,
      authorHandle: handle.isEmpty ? null : handle,
      lastEdited: true,
      dabUserId: senderUserId,
    );
    final activities = dto.toActivities(
      users,
      forUserIds: const <String>[],
      followerUserIds: followers,
      senderUserId: senderUserId,
    );
    if (activities.isEmpty) {
      return const Right(
        FigmaWebhookIngestionResult.ignored('no_eligible_activities'),
      );
    }

    return _persister.persist(
      activities: activities,
      providerId: 'figma',
      emptyReason: 'duplicate_activity',
      logTag: 'FIGMA_WEBHOOK',
      replaceExisting: true,
    );
  }

  String _eventType(Map<String, dynamic> payload) {
    return (payload['event_type'] ?? payload['eventType'] ?? '')
        .toString()
        .trim()
        .toUpperCase();
  }

  Map<String, dynamic>? _firstComment(Map<String, dynamic> payload) {
    final raw = payload['comment'] ?? payload['comments'];
    if (raw is Map<String, dynamic>) return raw;
    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return Map<String, dynamic>.from(raw.first as Map);
    }
    return null;
  }

  Map<String, dynamic>? _triggeredBy(Map<String, dynamic> payload) {
    return _userMap(payload['triggered_by'] ?? payload['triggeredBy']);
  }

  Map<String, dynamic>? _userMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  String? _handleOf(Map<String, dynamic>? user) {
    final label = figmaAuthorLabelFromUser(user);
    return label.isEmpty ? null : label;
  }

  String _commentMessage(Map<String, dynamic>? comment) {
    if (comment == null) return '';
    return (comment['message'] ?? comment['text'] ?? '').toString();
  }

  List<String> _mentionIds(Map<String, dynamic>? comment) {
    if (comment == null) return const [];
    final raw = comment['mentions'] ?? comment['mentioned_users'];
    if (raw is! List) return const [];
    final ids = <String>[];
    for (final item in raw) {
      if (item is String) {
        final id = item.trim();
        if (id.isNotEmpty) ids.add(id);
        continue;
      }
      if (item is Map) {
        final id = (item['id'] ?? '').toString().trim();
        if (id.isNotEmpty) ids.add(id);
      }
    }
    return ids;
  }

  String _displayFileTitle({
    required String fileKey,
    required Map<String, dynamic> payload,
    FigmaFileMeta? meta,
  }) {
    final metaName = (meta?.name ?? '').trim();
    final payloadName =
        (payload['file_name'] ?? payload['fileName'] ?? '').toString();
    return figmaFileTitle(
      name: metaName.isNotEmpty ? metaName : payloadName,
      folderName: meta?.folderName,
      fileKey: fileKey,
    );
  }

  DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw.toUtc();
    if (raw is num) {
      final n = raw.toInt();
      if (n > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(n, isUtc: true);
      }
      if (n > 1000000000) {
        return DateTime.fromMillisecondsSinceEpoch(n * 1000, isUtc: true);
      }
    }
    return DateTime.tryParse(raw.toString())?.toUtc();
  }
}
