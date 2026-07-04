import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/discord/discord_message_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/sources/discord/discord_message_source.dart';
import '../../../infrastructure/websockets/presence_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Discord Gateway `MESSAGE_CREATE` dispatches into the DAB
/// live pipeline.
/// CONTRACT: Payloads carry the full message model, so no API callback is
/// needed. Rows are shaped identically to polling via
/// [mapDiscordMessageJson] + [OnDiscordMessageDto.toActivities]. Only
/// messages in the configured channel allow-list (when set) and authored by
/// linked identities are persisted.
/// CONSTRAINTS: Read-only toward Discord; dedupe on message snowflake id.
class IngestDiscordMessage {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;

  IngestDiscordMessage(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService,
  );

  Future<Either<Failure, DiscordMessageIngestionResult>> execute({
    required Map<String, dynamic> payload,
  }) async {
    final messageId = (payload['id'] ?? '').toString().trim();
    if (messageId.isEmpty) {
      return const Right(
        DiscordMessageIngestionResult.ignored('missing_message_id'),
      );
    }

    final reserved = await _redisService.reserveIngestionEventId(
      'discord',
      messageId,
    );
    if (!reserved) {
      return const Right(
        DiscordMessageIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final discordConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'discord' && config.isActive,
        )
        .firstOrNull;
    if (discordConfig == null) {
      return const Right(
        DiscordMessageIngestionResult.ignored('discord_not_configured'),
      );
    }

    // Respect the channel allow-list when configured (empty = all channels).
    final allowedChannels = discordChannelIds(discordConfig.settings);
    final channelId = (payload['channel_id'] ?? '').toString().trim();
    if (allowedChannels.isNotEmpty && !allowedChannels.contains(channelId)) {
      return const Right(
        DiscordMessageIngestionResult.ignored('channel_not_configured'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(
        DiscordMessageIngestionResult.ignored('no_users_found'),
      );
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'discord');
    final externalToUser = <String, String>{};
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final key = identity.externalId.trim();
      if (key.isEmpty) continue;
      externalToUser.putIfAbsent(key, () => identity.userId);
    }
    if (externalToUser.isEmpty) {
      return const Right(
        DiscordMessageIngestionResult.ignored('no_linked_discord_identities'),
      );
    }

    final guildId = (discordConfig.settings['guildId'] ?? '').toString().trim();
    final dto = mapDiscordMessageJson(
      payload,
      fallbackChannelId: channelId,
      guildId: guildId.isEmpty ? null : guildId,
      externalToUser: externalToUser,
    );
    if (dto == null) {
      return const Right(
        DiscordMessageIngestionResult.ignored('invalid_message_payload'),
      );
    }
    if (dto.dabUserId == null) {
      return const Right(
        DiscordMessageIngestionResult.ignored('no_attributable_users'),
      );
    }

    final activities = dto.toActivities(users);
    if (activities.isEmpty) {
      return const Right(
        DiscordMessageIngestionResult.ignored('no_eligible_activities'),
      );
    }

    var ingestedCount = 0;
    for (final activity in activities) {
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
      await _redisService.incrementVersion();
      await _redisService.fanOutActivity(activity);
      _presenceService.broadcastToUser(
        activity.userId,
        'ACTIVITY_RECEIVED',
        activity.toMap(),
      );
      print(
        '[DISCORD_GATEWAY] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return const Right(
        DiscordMessageIngestionResult.ignored('duplicate_activity'),
      );
    }
    await _redisService.recordLiveIngestSuccess('discord');
    return const Right(DiscordMessageIngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for Discord Gateway processing (parity with webhooks).
class DiscordMessageIngestionResult {
  final bool ingested;
  final String reason;

  const DiscordMessageIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const DiscordMessageIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const DiscordMessageIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
