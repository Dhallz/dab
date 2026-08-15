import 'package:fpdart/fpdart.dart';

import '../../../domain/core/discord_scope.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/discord/discord_message_dto.dart';
import '../../../domain/dtos/discord/discord_message_mapping.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/i_discord_live_ingestor.dart';
import '../../../domain/contracts/ports/i_live_feed_store.dart';
import '../../../domain/contracts/ports/i_presence_broadcaster.dart';
import '../../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../services/activity_live_publisher.dart';
import '../../services/live_ingest_persister.dart';
import 'ingestion_result.dart';

export 'ingestion_result.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Discord Gateway `MESSAGE_CREATE` dispatches into the DAB
/// live pipeline.
/// CONTRACT: Payloads carry the full message model, so no API callback is
/// needed. Rows are shaped identically to polling via
/// [mapDiscordMessageJson] + [OnDiscordMessageDto.toActivities]. Only
/// messages in the configured channel allow-list (when set) and authored by
/// linked identities are persisted.
/// CONSTRAINTS: Read-only toward Discord; dedupe on message snowflake id.
class IngestDiscordMessage implements IDiscordLiveIngestor {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final ILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;

  IngestDiscordMessage(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._liveFeed,
    IPresenceBroadcaster presence, {
    ActivityLivePublisher? livePublisher,
    LiveIngestPersister? persister,
  }) : _persister =
           persister ??
           LiveIngestPersister(
             activities: activityRepository,
             liveFeed: _liveFeed,
             presence: presence,
             livePublisher: livePublisher,
           );

  @override
  Future<Either<Failure, void>> ingestMessageCreate(
    Map<String, dynamic> payload,
  ) async {
    final result = await execute(payload: payload);
    return result.map((_) {});
  }

  Future<Either<Failure, DiscordMessageIngestionResult>> execute({
    required Map<String, dynamic> payload,
  }) async {
    final messageId = (payload['id'] ?? '').toString().trim();
    if (messageId.isEmpty) {
      return const Right(
        DiscordMessageIngestionResult.ignored('missing_message_id'),
      );
    }

    final reserved = await _liveFeed.reserveIngestionEventId(
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

    return _persister.persist(
      activities: activities,
      providerId: 'discord',
      emptyReason: 'duplicate_activity',
      logTag: 'DISCORD_GATEWAY',
    );
  }
}
