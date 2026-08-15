import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/slack/slack_message_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/domain/contracts/ports/i_discovery_source.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/slack_web_protocol.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Slack Message retrieval.
/// CONTRACT: Fetches technical [SlackMessageDto] from the Slack Web API.
/// CONSTRAINTS: Must be READ-ONLY.
class SlackMessageSource
    implements IActivitySource<SlackMessageDto>, IDiscoverySource {
  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final SlackWebProtocol _slack;

  SlackMessageSource(this._configRepository, this._userRepository, this._slack);

  @override
  Future<List<SlackMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final configsResult = await _configRepository.getConfigs();
    final config = configsResult
        .getOrElse((_) => [])
        .where((c) => c.id == 'slack' && c.isActive)
        .firstOrNull;
    if (config == null) {
      return const [];
    }

    final settings = config.settings;
    final token = _resolveToken(settings);
    if (token.isEmpty) {
      return const [];
    }

    final apiBaseUrl = _resolveApiBaseUrl(settings);
    final channels = _extractChannels(settings);
    if (channels.isEmpty) {
      return const [];
    }
    final workspaceId = await _resolveWorkspaceTeamId(
      settings: settings,
      apiBaseUrl: apiBaseUrl,
      token: token,
    );

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'slack');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) {
      return const [];
    }

    final userIdBySlackId = {
      for (final identity in linkedIdentities)
        identity.externalId.trim(): identity.userId,
    };
    final slackUsernameBySlackId = {
      for (final identity in linkedIdentities)
        if ((identity.externalUsername ?? '').trim().isNotEmpty)
          identity.externalId.trim(): identity.externalUsername!.trim(),
    };
    final allowedSlackIds = userIdBySlackId.keys.toSet();
    if (authoredOnly && allowedSlackIds.isEmpty) {
      return const [];
    }

    final userById = {for (final user in users) user.id: user};
    final dtos = <SlackMessageDto>[];
    final seen = <String>{};
    for (final channelId in channels) {
      final channelLabel = await _resolveConversationLabel(
        apiBaseUrl: apiBaseUrl,
        token: token,
        channelId: channelId,
      );
      final rawMessages = await _fetchChannelMessages(
        apiBaseUrl: apiBaseUrl,
        token: token,
        channelId: channelId,
        start: start,
        end: end,
      );
      if (rawMessages.isEmpty) {
        continue;
      }

      final referencedSlackIds = <String>{
        for (final message in rawMessages)
          (message['user'] ?? '').toString().trim(),
        for (final message in rawMessages)
          ..._extractMentionIds((message['text'] ?? '').toString()),
      }..removeWhere((id) => id.isEmpty);
      final resolvedUsernamesBySlackId = await _resolveSlackUsernamesById(
        apiBaseUrl: apiBaseUrl,
        token: token,
        slackIds: referencedSlackIds,
        seeded: slackUsernameBySlackId,
      );

      for (final message in rawMessages) {
        final slackUserId = (message['user'] ?? '').toString().trim();
        if (slackUserId.isEmpty) continue;

        if (authoredOnly && !allowedSlackIds.contains(slackUserId)) continue;

        final dabUserId = userIdBySlackId[slackUserId];
        if (dabUserId == null || dabUserId.isEmpty) continue;

        final ts = (message['ts'] ?? '').toString().trim();
        if (ts.isEmpty) continue;

        final dedupeKey = '$channelId:$ts';
        if (!seen.add(dedupeKey)) continue;

        final createdAt = _parseSlackTs(ts);
        if (createdAt == null) continue;

        final user = userById[dabUserId];
        final normalizedText = _normalizeMessageText(
          (message['text'] ?? '').toString(),
          resolvedUsernamesBySlackId,
        );
        dtos.add(
          SlackMessageDto(
            channelId: channelId,
            channelLabel: channelLabel,
            workspaceId: workspaceId,
            text: normalizedText,
            userId: slackUserId,
            ts: ts,
            threadTs: (message['thread_ts'] ?? '').toString().trim().isEmpty
                ? null
                : message['thread_ts'].toString().trim(),
            permalink: _buildPermalink(
              baseUrl: config.baseUrl,
              workspaceId: workspaceId,
              channelId: channelId,
              ts: ts,
              threadTs: (message['thread_ts'] ?? '').toString().trim().isEmpty
                  ? null
                  : message['thread_ts'].toString().trim(),
            ),
            userDisplayName: user?.name,
            userUsername: resolvedUsernamesBySlackId[slackUserId],
            userAvatarUrl: user?.avatarUrl,
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

    final configsResult = await _configRepository.getConfigs();
    final config = configsResult
        .getOrElse((_) => [])
        .where((c) => c.id == 'slack' && c.isActive)
        .firstOrNull;
    if (config == null) {
      return const Right(null);
    }

    final token = _resolveToken(config.settings);
    if (token.isEmpty) {
      return const Right(null);
    }

    final uri = Uri.parse(
      '${_resolveApiBaseUrl(config.settings)}/users.lookupByEmail',
    ).replace(queryParameters: {'email': normalizedEmail});
    try {
      final decoded = await _slack.getJson(
        uri,
        bearerToken: token,
        timeout: const Duration(seconds: 12),
      );
      final user = decoded['user'] as Map<String, dynamic>?;
      final userId = user?['id']?.toString().trim();
      if (userId == null || userId.isEmpty) {
        return const Right(null);
      }
      return Right(userId);
    } on ProtocolException catch (_) {
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  Future<List<Map<String, dynamic>>> _fetchChannelMessages({
    required String apiBaseUrl,
    required String token,
    required String channelId,
    required DateTime start,
    required DateTime end,
  }) async {
    final oldest = (start.toUtc().millisecondsSinceEpoch / 1000).toString();
    final latest = (end.toUtc().millisecondsSinceEpoch / 1000).toString();
    var cursor = '';
    var pages = 0;
    final allMessages = <Map<String, dynamic>>[];

    while (pages < 5) {
      final queryParameters = {
        'channel': channelId,
        'oldest': oldest,
        'latest': latest,
        'inclusive': 'true',
        'limit': '200',
        if (cursor.isNotEmpty) 'cursor': cursor,
      };
      final uri = Uri.parse(
        '$apiBaseUrl/conversations.history',
      ).replace(queryParameters: queryParameters);

      try {
        final decoded = await _slack.getJson(
          uri,
          bearerToken: token,
          timeout: const Duration(seconds: 12),
        );

        final messages = decoded['messages'];
        if (messages is List) {
          allMessages.addAll(messages.whereType<Map<String, dynamic>>());
        }

        final metadata = decoded['response_metadata'] as Map<String, dynamic>?;
        final nextCursor = metadata?['next_cursor']?.toString() ?? '';
        if (nextCursor.isEmpty) {
          break;
        }

        cursor = nextCursor;
        pages += 1;
      } on ProtocolException catch (_) {
        return const [];
      } catch (_) {
        return const [];
      }
    }

    return allMessages;
  }

  String _resolveToken(Map<String, dynamic> settings) {
    return extractProviderToken('slack', settings);
  }

  String _resolveApiBaseUrl(Map<String, dynamic> settings) {
    final configured = (settings['apiBaseUrl'] ?? '').toString().trim();
    return (configured.isEmpty ? 'https://slack.com/api' : configured)
        .replaceAll(RegExp(r'/+$'), '');
  }

  Future<String?> _resolveWorkspaceTeamId({
    required Map<String, dynamic> settings,
    required String apiBaseUrl,
    required String token,
  }) async {
    final configured = _extractTeamId(
      (settings['workspaceId'] ?? settings['teamId'] ?? '').toString(),
    );
    if (configured != null) {
      return configured;
    }

    return _fetchTeamIdFromAuthTest(apiBaseUrl: apiBaseUrl, token: token);
  }

  String? _extractTeamId(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    final match = RegExp(
      r'\bT[0-9A-Z]+\b',
      caseSensitive: false,
    ).firstMatch(value);
    if (match == null) {
      return null;
    }

    final teamId = match.group(0)?.trim().toUpperCase();
    if (teamId == null || teamId.isEmpty) {
      return null;
    }
    return teamId;
  }

  Future<String?> _fetchTeamIdFromAuthTest({
    required String apiBaseUrl,
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$apiBaseUrl/auth.test');
      final decoded = await _slack.postJson(
        uri,
        bearerToken: token,
        timeout: const Duration(seconds: 10),
      );
      final teamId = _extractTeamId(decoded['team_id']?.toString() ?? '');
      return teamId;
    } on ProtocolException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  List<String> _extractChannels(Map<String, dynamic> settings) {
    final channels = <String>{};
    final channelsRaw = settings['channels'];
    if (channelsRaw is List) {
      for (final entry in channelsRaw) {
        final channel = entry.toString().trim();
        if (channel.isNotEmpty) {
          channels.add(channel);
        }
      }
    } else if (channelsRaw is String) {
      channels.addAll(
        channelsRaw
            .split(RegExp(r'[\n,]+'))
            .map((c) => c.trim())
            .where((c) => c.isNotEmpty),
      );
    }

    final singleChannel = (settings['channel'] ?? '').toString().trim();
    if (singleChannel.isNotEmpty) {
      channels.add(singleChannel);
    }

    return channels.toList();
  }

  DateTime? _parseSlackTs(String ts) {
    final seconds = double.tryParse(ts);
    if (seconds == null) {
      return null;
    }
    final millis = (seconds * 1000).round();
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }

  String? _buildPermalink({
    required String baseUrl,
    required String? workspaceId,
    required String channelId,
    required String ts,
    required String? threadTs,
  }) {
    final messageTs = ts.trim();
    final rootThreadTs = (threadTs ?? '').trim();

    if (workspaceId != null && workspaceId.trim().isNotEmpty) {
      // Prefer direct app deep-link when workspace id is known.
      final deepLink = Uri(
        scheme: 'slack',
        host: 'channel',
        queryParameters: {
          'team': workspaceId.trim(),
          'id': channelId,
          // `ts` is not officially documented for slack://channel, but is the
          // most reliable in-client hint for focusing the exact message.
          'ts': messageTs,
          // Keep `message` too for client compatibility across versions.
          'message': messageTs,
          if (rootThreadTs.isNotEmpty) 'thread_ts': rootThreadTs,
        },
      );
      return deepLink.toString();
    }
    final normalizedBaseUrl = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    if (normalizedBaseUrl.isEmpty) {
      return null;
    }
    final tsValue = messageTs.replaceAll('.', '');
    final uri = Uri.parse('$normalizedBaseUrl/archives/$channelId/p$tsValue');
    if (rootThreadTs.isEmpty) {
      return uri.toString();
    }

    return uri
        .replace(queryParameters: {'thread_ts': rootThreadTs, 'cid': channelId})
        .toString();
  }

  Set<String> _extractMentionIds(String text) {
    final matches = RegExp(r'<@([A-Z0-9]+)>').allMatches(text);
    return {for (final match in matches) match.group(1) ?? ''};
  }

  String _normalizeMessageText(
    String text,
    Map<String, String> usernameBySlackId,
  ) {
    if (text.isEmpty) {
      return text;
    }
    return text.replaceAllMapped(RegExp(r'<@([A-Z0-9]+)>'), (match) {
      final slackId = match.group(1) ?? '';
      final username = usernameBySlackId[slackId];
      if (username == null || username.isEmpty) {
        return '@$slackId';
      }
      return '@$username';
    });
  }

  Future<Map<String, String>> _resolveSlackUsernamesById({
    required String apiBaseUrl,
    required String token,
    required Set<String> slackIds,
    required Map<String, String> seeded,
  }) async {
    final result = Map<String, String>.from(seeded);
    final unresolved = slackIds.where((id) => !result.containsKey(id)).take(30);
    for (final slackId in unresolved) {
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
      final decoded = await _slack.getJson(
        uri,
        bearerToken: token,
        timeout: const Duration(seconds: 10),
      );
      final user = decoded['user'] as Map<String, dynamic>?;
      final profile = user?['profile'] as Map<String, dynamic>?;
      final username = user?['name']?.toString().trim();
      final displayName = profile?['display_name']?.toString().trim();
      if (displayName != null && displayName.isNotEmpty) {
        return displayName;
      }
      if (username != null && username.isNotEmpty) {
        return username;
      }
      return null;
    } on ProtocolException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _resolveConversationLabel({
    required String apiBaseUrl,
    required String token,
    required String channelId,
  }) async {
    try {
      final uri = Uri.parse(
        '$apiBaseUrl/conversations.info',
      ).replace(queryParameters: {'channel': channelId});
      final decoded = await _slack.getJson(
        uri,
        bearerToken: token,
        timeout: const Duration(seconds: 10),
      );
      final channel = decoded['channel'] as Map<String, dynamic>? ?? const {};
      final isIm = channel['is_im'] == true;
      if (isIm) {
        final dmWithId = channel['user']?.toString().trim() ?? '';
        if (dmWithId.isNotEmpty) {
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
        return 'DM';
      }

      final name = channel['name']?.toString().trim() ?? '';
      if (name.isNotEmpty) {
        return '#$name';
      }
      return '#$channelId';
    } on ProtocolException catch (_) {
      return '#$channelId';
    } catch (_) {
      return '#$channelId';
    }
  }
}
