import 'package:dab_api/src/domain/core/figma_scope.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/figma/figma_file_dto.dart';
import 'package:dab_api/src/domain/entities/figma/figma_file_meta.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_figma_file_gateway.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_credential_refresher.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only Figma comments and last-touched snapshots for Explorer poll.
/// CONTRACT: Returns [FigmaFileDto] rows. Never writes to Figma. Connect OAuth
/// cannot list a team (`projects:read` / `folders:read` are not requested);
/// poll keys come from Admin file keys/URLs plus Follow pins.
class FigmaFileSource
    implements AbsIActivitySource<FigmaFileDto>, AbsIFigmaFileGateway {
  FigmaFileSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
    this._credentials, {
    AbsIActivityFollowRepository? follows,
    AbsIOauthCredentialRefresher? oauth,
  }) : _follows = follows,
       _oauth = oauth;

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;
  final AbsICredentialResolver _credentials;
  final AbsIActivityFollowRepository? _follows;
  final AbsIOauthCredentialRefresher? _oauth;

  @override
  Future<List<FigmaFileDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeConfig();
    if (cfg == null) return const [];
    final initialToken = await _resolveToken(cfg, users);
    if (initialToken == null || initialToken.isEmpty) {
      print(
        '[FIGMA_POLL] no Figma token; Connect with Figma or set Admin api.token',
      );
      return const [];
    }
    var token = initialToken;
    var retriedExpiredToken = false;

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'figma');
    final linked = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    final userIdByFigma = <String, String>{};
    final userIdByHandle = <String, String>{};
    for (final identity in linked) {
      final externalId = identity.externalId.trim();
      if (externalId.isNotEmpty) userIdByFigma[externalId] = identity.userId;
      final handle = (identity.externalUsername ?? '').trim().toLowerCase();
      if (handle.isNotEmpty) {
        userIdByHandle.putIfAbsent(handle, () => identity.userId);
      }
    }

    final files = await _fileCatalog(cfg, token, users);
    if (files.isEmpty) {
      print(
        '[FIGMA_POLL] no files to poll; paste Admin Figma file URLs or Follow a file',
      );
      return const [];
    }

    final startUtc = start.toUtc();
    final endUtc = end.toUtc();
    final out = <FigmaFileDto>[];
    for (final file in files) {
      var comments = const <_FigmaCommentRow>[];
      try {
        comments = await _fetchComments(file.key, token);
      } on JsonRestProtocolException catch (e) {
        if (e.statusCode != 401 || retriedExpiredToken) {
          print('[FIGMA_POLL] comments failed file=${file.key} error=$e');
          comments = const [];
        } else {
          retriedExpiredToken = true;
          final next = await _resolveToken(cfg, users, forceRefresh: true);
          if (next == null || next.isEmpty) {
            print(
              '[FIGMA_POLL] Figma token expired; Connect with Figma again',
            );
            return const [];
          }
          token = next;
          try {
            comments = await _fetchComments(file.key, token);
          } on JsonRestProtocolException catch (retryError) {
            print(
              '[FIGMA_POLL] comments failed file=${file.key} error=$retryError',
            );
            comments = const [];
          }
        }
      }
      final meta = await _fetchMeta(file.key, token);
      final metaName = (meta?.name ?? '').trim();
      final fileLabel = figmaFileTitle(
        name: metaName.isNotEmpty ? metaName : file.name,
        folderName: meta?.folderName,
        fileKey: file.key,
      );
      for (final comment in comments) {
        if (comment.createdAt.isBefore(startUtc) ||
            !comment.createdAt.isBefore(endUtc)) {
          continue;
        }
        final authorId = comment.authorId.trim();
        final authorDab =
            userIdByFigma[authorId] ??
            (comment.authorHandle.trim().isEmpty
                ? null
                : userIdByHandle[comment.authorHandle.trim().toLowerCase()]);
        final mentionedDab = [
          for (final mentionId in comment.mentionIds)
            if (userIdByFigma[mentionId.trim()] != null)
              userIdByFigma[mentionId.trim()]!,
        ];
        final fallbackUserId = users.isEmpty ? null : users.first.id;
        if (authoredOnly &&
            authorDab == null &&
            mentionedDab.isEmpty &&
            fallbackUserId == null) {
          continue;
        }
        out.add(
          FigmaFileDto(
            fileKey: file.key,
            fileName: fileLabel,
            createdAt: comment.createdAt,
            commentId: comment.id,
            commentMessage: comment.message,
            parentId: comment.parentId,
            authorId: authorId.isEmpty ? null : authorId,
            authorHandle: comment.authorHandle,
            mentionIds: comment.mentionIds,
            dabUserId: authorDab ?? mentionedDab.firstOrNull ?? fallbackUserId,
          ),
        );
      }

      final touchedAt = meta?.lastTouchedAt;
      if (touchedAt == null) continue;
      if (touchedAt.isBefore(startUtc) || !touchedAt.isBefore(endUtc)) {
        continue;
      }
      final touchedId = (meta?.lastTouchedById ?? '').trim();
      out.add(
        FigmaFileDto(
          fileKey: file.key,
          fileName: fileLabel,
          createdAt: touchedAt,
          authorId: touchedId.isEmpty ? null : touchedId,
          authorHandle: meta?.lastTouchedByHandle,
          lastEdited: true,
          dabUserId: touchedId.isEmpty ? null : userIdByFigma[touchedId],
        ),
      );
    }
    return out;
  }

  @override
  Future<FigmaFileMeta?> fetchFileMeta(String fileKey) async {
    final cfg = await _activeConfig();
    if (cfg == null) return null;
    final token = await _resolveToken(cfg, const []);
    if (token == null || token.isEmpty) return null;
    return _fetchMeta(fileKey, token);
  }

  Future<FigmaFileMeta?> _fetchMeta(String fileKey, String token) async {
    try {
      final body = await _jsonRest.getJsonMap(
        Uri.parse('$kFigmaApiBase/v1/files/${fileKey.trim()}/meta'),
        headers: figmaAuthHeaders(token),
      );
      final fields = figmaFileMetaFields(body);
      final person = fields['last_touched_by'];
      Map<String, dynamic>? user;
      if (person is Map) user = Map<String, dynamic>.from(person);
      final handle = (user?['handle'] ?? user?['name'] ?? '').toString().trim();
      final id = (user?['id'] ?? '').toString().trim();
      final name = (fields['name'] ?? '').toString().trim();
      final folder = (fields['folder_name'] ?? '').toString().trim();
      return FigmaFileMeta(
        fileKey: fileKey.trim(),
        name: name.isEmpty ? null : name,
        folderName: folder.isEmpty ? null : folder,
        lastTouchedById: id.isEmpty ? null : id,
        lastTouchedByHandle: handle.isEmpty ? null : handle,
        lastTouchedAt: DateTime.tryParse(
          (fields['last_touched_at'] ?? '').toString(),
        )?.toUtc(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<_FigmaCommentRow>> _fetchComments(
    String fileKey,
    String token,
  ) async {
    try {
      final body = await _jsonRest.getJsonMap(
        Uri.parse('$kFigmaApiBase/v1/files/${fileKey.trim()}/comments'),
        headers: figmaAuthHeaders(token),
      );
      final raw = body['comments'];
      if (raw is! List) return const [];
      final out = <_FigmaCommentRow>[];
      for (final item in raw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final id = (map['id'] ?? '').toString().trim();
        if (id.isEmpty) continue;
        final created =
            DateTime.tryParse(
              (map['created_at'] ?? map['createdAt'] ?? '').toString(),
            )?.toUtc() ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final user = map['user'];
        Map<String, dynamic>? userMap;
        if (user is Map) userMap = Map<String, dynamic>.from(user);
        out.add(
          _FigmaCommentRow(
            id: id,
            message: (map['message'] ?? map['text'] ?? '').toString(),
            parentId: (map['parent_id'] ?? map['parentId'] ?? '')
                .toString()
                .trim(),
            createdAt: created,
            authorId: (userMap?['id'] ?? '').toString().trim(),
            authorHandle: figmaAuthorLabelFromUser(userMap),
            mentionIds: _mentionIds(map),
          ),
        );
      }
      return out;
    } on JsonRestProtocolException catch (e) {
      if (e.statusCode == 401) rethrow;
      print('[FIGMA_POLL] comments failed file=$fileKey error=$e');
      return const [];
    } catch (e) {
      print('[FIGMA_POLL] comments failed file=$fileKey error=$e');
      return const [];
    }
  }

  List<String> _mentionIds(Map<String, dynamic> comment) {
    final raw = comment['mentions'] ?? comment['mentioned_users'];
    if (raw is! List) return const [];
    final ids = <String>[];
    for (final item in raw) {
      if (item is String && item.trim().isNotEmpty) {
        ids.add(item.trim());
      } else if (item is Map) {
        final id = (item['id'] ?? '').toString().trim();
        if (id.isNotEmpty) ids.add(id);
      }
    }
    return ids;
  }

  Future<List<_FigmaFileRef>> _fileCatalog(
    ProviderConfig cfg,
    String token,
    List<User> users,
  ) async {
    final seen = <String>{};
    final out = <_FigmaFileRef>[];

    void add(String key, String name) {
      final trimmed = key.trim();
      if (trimmed.isEmpty || !seen.add(trimmed)) return;
      final label = name.trim().isEmpty ? trimmed : name.trim();
      out.add(_FigmaFileRef(key: trimmed, name: label));
    }

    for (final key in parseFigmaFileKeys(cfg.settings['fileKeys'])) {
      add(key, key);
    }

    final userSettings = await _credentials.getUserSettingsForUsers(
      userIds: users.map((u) => u.id),
      providerId: 'figma',
    );
    for (final settings in userSettings.values) {
      for (final key in parseFigmaFileKeys(settings['fileKeys'])) {
        add(key, key);
      }
    }

    final follows = _follows;
    if (follows != null) {
      for (final user in users) {
        final listed = await follows.listForUser(user.id);
        for (final follow in listed.getOrElse((_) => const [])) {
          if (follow.providerId.trim().toLowerCase() != 'figma') continue;
          final key = extractFigmaFileKey(follow.objectKey);
          if (key == null) continue;
          add(key, follow.title ?? key);
        }
      }
    }

    final teamIds = parseFigmaTeamIds(
      cfg.settings['teamIds'] ?? cfg.settings['teamId'],
    );
    for (final teamId in teamIds) {
      for (final file in await _filesForTeam(teamId, token)) {
        add(file.key, file.name);
      }
    }
    return out;
  }

  Future<List<_FigmaFileRef>> _filesForTeam(
    String teamId,
    String token,
  ) async {
    try {
      final projectsBody = await _jsonRest.getJsonMap(
        Uri.parse('$kFigmaApiBase/v1/teams/$teamId/projects'),
        headers: figmaAuthHeaders(token),
      );
      final projects = projectsBody['projects'];
      if (projects is! List) return const [];
      final out = <_FigmaFileRef>[];
      for (final project in projects) {
        if (project is! Map) continue;
        final projectId = (project['id'] ?? '').toString().trim();
        if (projectId.isEmpty) continue;
        final filesBody = await _jsonRest.getJsonMap(
          Uri.parse('$kFigmaApiBase/v1/projects/$projectId/files'),
          headers: figmaAuthHeaders(token),
        );
        final files = filesBody['files'];
        if (files is! List) continue;
        for (final file in files) {
          if (file is! Map) continue;
          final key = (file['key'] ?? '').toString().trim();
          if (key.isEmpty) continue;
          final name = (file['name'] ?? key).toString().trim();
          out.add(_FigmaFileRef(key: key, name: name));
        }
      }
      return out;
    } catch (e) {
      print('[FIGMA_POLL] team catalog failed team=$teamId error=$e');
      return const [];
    }
  }

  Future<String?> _resolveToken(
    ProviderConfig cfg,
    List<User> users, {
    bool forceRefresh = false,
  }) async {
    var ids = users.map((u) => u.id).toList();
    if (ids.isEmpty) {
      final all = (await _userRepository.getUsers()).getOrElse(
        (_) => const <User>[],
      );
      ids = all.map((u) => u.id).toList();
    }
    final userToken = await _userOauthToken(
      cfg,
      ids,
      forceRefresh: forceRefresh,
    );
    if (userToken != null && userToken.isNotEmpty) return userToken;
    final orgToken = extractProviderToken('figma', cfg.settings);
    if (orgToken.isNotEmpty) return orgToken;
    return null;
  }

  Future<String?> _userOauthToken(
    ProviderConfig cfg,
    List<String> userIds, {
    required bool forceRefresh,
  }) async {
    if (userIds.isEmpty) return null;
    for (final userId in userIds) {
      Map<String, dynamic>? settings;
      final oauth = _oauth;
      if (oauth != null) {
        final fresh = await oauth.ensureFresh(
          userId: userId,
          providerId: 'figma',
          force: forceRefresh,
        );
        if (fresh.isLeft()) {
          print(
            '[FIGMA_POLL] ${fresh.getLeft().toNullable()?.message ?? 'Figma token refresh failed'}',
          );
          continue;
        }
        settings = fresh.getOrElse((_) => const {});
      } else {
        settings = await _credentials.getUserSettings(
          userId: userId,
          providerId: 'figma',
        );
      }
      if (settings == null || settings.isEmpty) continue;
      final merged = _credentials.overlay(
        orgSettings: cfg.settings,
        userSettings: settings,
      );
      final token = extractProviderToken('figma', merged);
      if (token.isNotEmpty) return token;
    }
    return null;
  }

  Future<ProviderConfig?> _activeConfig() async {
    final configs = (await _configRepository.getConfigs()).getOrElse(
      (_) => const [],
    );
    for (final c in configs) {
      if (c.id == 'figma' && c.isActive) return c;
    }
    return null;
  }
}

class _FigmaFileRef {
  final String key;
  final String name;
  const _FigmaFileRef({required this.key, required this.name});
}

class _FigmaCommentRow {
  final String id;
  final String message;
  final String parentId;
  final DateTime createdAt;
  final String authorId;
  final String authorHandle;
  final List<String> mentionIds;

  const _FigmaCommentRow({
    required this.id,
    required this.message,
    required this.parentId,
    required this.createdAt,
    required this.authorId,
    required this.authorHandle,
    required this.mentionIds,
  });
}
