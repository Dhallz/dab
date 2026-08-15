import 'package:dab_api/src/domain/core/discord_scope.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/discord/discord_message_dto.dart';
import 'package:dab_api/src/domain/dtos/discord/discord_message_mapping.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only Discord message retrieval via the Discord REST API v10.
/// CONTRACT: Returns [DiscordMessageDto] rows for [UnifiedActivityFetcher];
/// attribution is identity-based (`provider_id: discord` linked rows, external
/// id = Discord user snowflake). Auth: bot token (`botToken` setting), channel
/// allow-list from the `channels` setting.
/// CONSTRAINTS: Must be READ-ONLY; bot-authored messages are skipped.
class DiscordMessageSource
    implements IActivitySource<DiscordMessageDto>, IDiscoverySource {
  DiscordMessageSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;

  static const _apiBase = 'https://discord.com/api/v10';

  @override
  Future<List<DiscordMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeDiscordConfig();
    if (cfg == null) return const [];

    final botToken = extractProviderToken('discord', cfg.settings);
    if (botToken.isEmpty) return const [];

    final channelIds = discordChannelIds(cfg.settings);
    if (channelIds.isEmpty) return const [];

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'discord');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) return const [];

    final externalToUser = {
      for (final i in linkedIdentities) i.externalId: i.userId,
    };
    final guildId = (cfg.settings['guildId'] ?? '').toString().trim();
    final headers = _authHeaders(botToken);

    final results = <DiscordMessageDto>[];
    final seen = <String>{};

    for (final channelId in channelIds) {
      String? before;
      for (var page = 0; page < 10; page++) {
        final uri = Uri.parse('$_apiBase/channels/$channelId/messages')
            .replace(queryParameters: {'limit': '100', 'before': ?before});

        List<dynamic> items;
        try {
          items = await _jsonRest.getJsonList(uri, headers: headers);
        } catch (_) {
          break;
        }
        if (items.isEmpty) break;

        var reachedOlderThanWindow = false;
        for (final raw in items) {
          if (raw is! Map<String, dynamic>) continue;
          final dto = mapDiscordMessageJson(
            raw,
            fallbackChannelId: channelId,
            guildId: guildId.isEmpty ? null : guildId,
            externalToUser: externalToUser,
          );
          if (dto == null) continue;

          if (dto.createdAt.isBefore(start.toUtc())) {
            reachedOlderThanWindow = true;
            continue;
          }
          if (dto.createdAt.isAfter(end.toUtc())) continue;
          if (dto.dabUserId == null) continue;
          if (!seen.add(dto.messageId)) continue;
          results.add(dto);
        }

        final last = items.last;
        before = last is Map<String, dynamic>
            ? last['id']?.toString()
            : null;
        if (reachedOlderThanWindow || before == null || before.isEmpty) break;
      }
    }

    return results;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    final cfg = await _activeDiscordConfig();
    if (cfg == null) return const Right(null);

    final botToken = extractProviderToken('discord', cfg.settings);
    final guildId = (cfg.settings['guildId'] ?? '').toString().trim();
    if (botToken.isEmpty || guildId.isEmpty) return const Right(null);

    final query = name.trim();
    if (query.isEmpty) return const Right(null);

    final uri = Uri.parse('$_apiBase/guilds/$guildId/members/search').replace(
      queryParameters: {'query': query, 'limit': '1'},
    );

    try {
      final list = await _jsonRest.getJsonList(
        uri,
        headers: _authHeaders(botToken),
      );
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final user = raw['user'];
        if (user is! Map<String, dynamic>) continue;
        final id = user['id']?.toString().trim();
        if (id != null && id.isNotEmpty) return Right(id);
      }
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  Future<ProviderConfig?> _activeDiscordConfig() async {
    final configsResult = await _configRepository.getConfigs();
    final configs = configsResult.getOrElse((_) => <ProviderConfig>[]);
    for (final c in configs) {
      if (c.id == 'discord' && c.isActive) return c;
    }
    return null;
  }

  Map<String, String> _authHeaders(String botToken) {
    return {'Authorization': 'Bot $botToken', 'Accept': 'application/json'};
  }
}
