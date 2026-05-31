import 'package:dab_api/src/domain/dtos/teams/teams_message_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/teams/microsoft_graph_token_client.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O handler for Microsoft Teams message retrieval via Graph.
/// CONTRACT: Fetches [TeamsMessageDto] from channel message endpoints.
/// CONSTRAINTS: Read-only. Linked-identity attribution only.
class TeamsMessageSource
    implements IActivitySource<TeamsMessageDto>, IDiscoverySource {
  static const _graphBase = 'https://graph.microsoft.com/v1.0';

  TeamsMessageSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest, [
    MicrosoftGraphTokenClient? tokenClient,
  ]) : _tokenClient = tokenClient ?? const MicrosoftGraphTokenClient();

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;
  final MicrosoftGraphTokenClient _tokenClient;

  @override
  Future<List<TeamsMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final config = await _activeTeamsConfig();
    if (config == null) {
      return const [];
    }

    final settings = config.settings;
    final tenantId = _setting(settings, 'tenantId');
    final clientId = _setting(settings, 'clientId');
    final clientSecret = _setting(settings, 'clientSecret');
    if (tenantId.isEmpty || clientId.isEmpty || clientSecret.isEmpty) {
      return const [];
    }

    final token = await _tokenClient.fetchAppToken(
      tenantId: tenantId,
      clientId: clientId,
      clientSecret: clientSecret,
    );
    if (token == null || token.isEmpty) {
      return const [];
    }

    final channels = _extractTeamChannels(settings);
    if (channels.isEmpty) {
      return const [];
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'teams');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) {
      return const [];
    }

    final userIdByGraphId = {
      for (final identity in linkedIdentities)
        identity.externalId.trim(): identity.userId,
    };
    final allowedGraphIds = userIdByGraphId.keys.toSet();
    if (authoredOnly && allowedGraphIds.isEmpty) {
      return const [];
    }

    final userById = {for (final user in users) user.id: user};
    final headers = _bearerHeaders(token);
    final startUtc = start.toUtc();
    final endUtc = end.toUtc();
    final dtos = <TeamsMessageDto>[];
    final seen = <String>{};

    for (final channel in channels) {
      final channelLabel = await _resolveChannelLabel(
        headers: headers,
        teamId: channel.teamId,
        channelId: channel.channelId,
      );
      final messages = await _fetchChannelMessages(
        headers: headers,
        teamId: channel.teamId,
        channelId: channel.channelId,
      );

      for (final message in messages) {
        final from = message['from'] as Map<String, dynamic>?;
        final user = from?['user'] as Map<String, dynamic>?;
        final graphUserId = user?['id']?.toString().trim() ?? '';
        if (graphUserId.isEmpty) continue;

        if (authoredOnly && !allowedGraphIds.contains(graphUserId)) continue;

        final dabUserId = userIdByGraphId[graphUserId];
        if (dabUserId == null || dabUserId.isEmpty) continue;

        final messageId = message['id']?.toString().trim() ?? '';
        if (messageId.isEmpty) continue;

        final dedupeKey = '${channel.teamId}:${channel.channelId}:$messageId';
        if (!seen.add(dedupeKey)) continue;

        final createdAt = _parseGraphDateTime(
          message['createdDateTime']?.toString(),
        );
        if (createdAt == null) continue;
        if (createdAt.isBefore(startUtc) || createdAt.isAfter(endUtc)) {
          continue;
        }

        final dabUser = userById[dabUserId];
        final body = message['body'] as Map<String, dynamic>?;
        final content = _plainTextFromBody(body?['content']?.toString() ?? '');

        dtos.add(
          TeamsMessageDto(
            teamId: channel.teamId,
            channelId: channel.channelId,
            channelLabel: channelLabel,
            tenantId: tenantId,
            messageId: messageId,
            replyToId: message['replyToId']?.toString().trim(),
            content: content,
            fromId: graphUserId,
            permalink: message['webUrl']?.toString().trim(),
            userDisplayName: dabUser?.name,
            userUsername: user?['displayName']?.toString().trim(),
            userAvatarUrl: dabUser?.avatarUrl,
            dabUserId: dabUserId,
            createdAt: createdAt,
          ),
        );
      }
    }

    return dtos;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) {
      return const Right(null);
    }

    final config = await _activeTeamsConfig();
    if (config == null) {
      return const Right(null);
    }

    final settings = config.settings;
    final tenantId = _setting(settings, 'tenantId');
    final clientId = _setting(settings, 'clientId');
    final clientSecret = _setting(settings, 'clientSecret');
    if (tenantId.isEmpty || clientId.isEmpty || clientSecret.isEmpty) {
      return const Right(null);
    }

    final token = await _tokenClient.fetchAppToken(
      tenantId: tenantId,
      clientId: clientId,
      clientSecret: clientSecret,
    );
    if (token == null || token.isEmpty) {
      return const Right(null);
    }

    final escaped = normalizedEmail.replaceAll("'", "''");
    final uri = Uri.parse('$_graphBase/users').replace(
      queryParameters: {
        r'$filter': "mail eq '$escaped' or userPrincipalName eq '$escaped'",
        r'$select': 'id',
        r'$top': '1',
      },
    );

    try {
      final decoded = await _jsonRest.getJsonMap(
        uri,
        headers: _bearerHeaders(token),
        timeout: const Duration(seconds: 12),
      );
      final value = decoded['value'];
      if (value is! List || value.isEmpty) {
        return const Right(null);
      }
      final first = value.first;
      if (first is! Map<String, dynamic>) {
        return const Right(null);
      }
      final graphId = first['id']?.toString().trim();
      if (graphId == null || graphId.isEmpty) {
        return const Right(null);
      }
      return Right(graphId);
    } on ProtocolException catch (_) {
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  Future<ProviderConfig?> _activeTeamsConfig() async {
    final configsResult = await _configRepository.getConfigs();
    return configsResult
        .getOrElse((_) => [])
        .where((c) => c.id == 'teams' && c.isActive)
        .firstOrNull;
  }

  Future<List<Map<String, dynamic>>> _fetchChannelMessages({
    required Map<String, String> headers,
    required String teamId,
    required String channelId,
  }) async {
    var uri = Uri.parse(
      '$_graphBase/teams/$teamId/channels/$channelId/messages',
    ).replace(queryParameters: {r'$top': '50'});

    var pages = 0;
    final all = <Map<String, dynamic>>[];

    while (pages < 5) {
      try {
        final decoded = await _jsonRest.getJsonMap(
          uri,
          headers: headers,
          timeout: const Duration(seconds: 15),
        );
        final value = decoded['value'];
        if (value is List) {
          all.addAll(value.whereType<Map<String, dynamic>>());
        }

        final next = decoded['@odata.nextLink']?.toString().trim() ?? '';
        if (next.isEmpty) {
          break;
        }
        uri = Uri.parse(next);
        pages += 1;
      } on ProtocolException catch (_) {
        return const [];
      } catch (_) {
        return const [];
      }
    }

    return all;
  }

  Future<String?> _resolveChannelLabel({
    required Map<String, String> headers,
    required String teamId,
    required String channelId,
  }) async {
    try {
      final uri = Uri.parse(
        '$_graphBase/teams/$teamId/channels/$channelId',
      );
      final decoded = await _jsonRest.getJsonMap(
        uri,
        headers: headers,
        timeout: const Duration(seconds: 10),
      );
      final displayName = decoded['displayName']?.toString().trim() ?? '';
      if (displayName.isNotEmpty) {
        return '#$displayName';
      }
    } on ProtocolException catch (_) {
      // fall through
    } catch (_) {
      // fall through
    }
    return '#$channelId';
  }

  String _setting(Map<String, dynamic> settings, String key) {
    return (settings[key] ?? '').toString().trim();
  }

  Map<String, String> _bearerHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  List<_TeamChannelRef> _extractTeamChannels(Map<String, dynamic> settings) {
    final refs = <_TeamChannelRef>{};
    final channelsRaw = settings['channels'];
    if (channelsRaw is List) {
      for (final entry in channelsRaw) {
        final parsed = _parseTeamChannelRef(entry.toString());
        if (parsed != null) {
          refs.add(parsed);
        }
      }
    } else if (channelsRaw is String) {
      for (final part in channelsRaw.split(RegExp(r'[\n,]+'))) {
        final parsed = _parseTeamChannelRef(part);
        if (parsed != null) {
          refs.add(parsed);
        }
      }
    }

    final single = _parseTeamChannelRef(
      (settings['channel'] ?? '').toString(),
    );
    if (single != null) {
      refs.add(single);
    }

    return refs.toList();
  }

  _TeamChannelRef? _parseTeamChannelRef(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    final separator = value.contains('/') ? '/' : ':';
    final parts = value.split(separator);
    if (parts.length < 2) {
      return null;
    }
    final teamId = parts.first.trim();
    final channelId = parts.sublist(1).join(separator).trim();
    if (teamId.isEmpty || channelId.isEmpty) {
      return null;
    }
    return _TeamChannelRef(teamId: teamId, channelId: channelId);
  }

  DateTime? _parseGraphDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw.trim())?.toUtc();
  }

  String _plainTextFromBody(String raw) {
    if (raw.isEmpty) {
      return raw;
    }
    return raw
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class _TeamChannelRef {
  const _TeamChannelRef({required this.teamId, required this.channelId});

  final String teamId;
  final String channelId;

  @override
  bool operator ==(Object other) =>
      other is _TeamChannelRef &&
      other.teamId == teamId &&
      other.channelId == channelId;

  @override
  int get hashCode => Object.hash(teamId, channelId);
}
