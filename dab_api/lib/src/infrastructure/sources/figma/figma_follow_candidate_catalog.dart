import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/figma_scope.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_follow_candidate_catalog.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../protocols/rest/json_rest_protocol.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists Figma files for the Follow picker when [query] is set.
/// CONTRACT: Empty query returns no rows. A pasted file URL or key is enough
/// even when Connect OAuth cannot list the team.
class FigmaFollowCandidateCatalog implements AbsIFollowCandidateCatalog {
  FigmaFollowCandidateCatalog(
    this._configs,
    this._credentials,
    this._jsonRest,
  );

  final AbsIProviderConfigRepository _configs;
  final AbsICredentialResolver _credentials;
  final JsonRestProtocol _jsonRest;

  @override
  String get providerId => 'figma';

  @override
  Future<Either<Failure, List<FollowCandidate>>> list({
    required String userId,
    required String query,
  }) async {
    if (query.trim().isEmpty) return const Right([]);
    try {
      return Right(await _list(userId: userId, query: query.trim()));
    } catch (_) {
      return const Right([]);
    }
  }

  Future<List<FollowCandidate>> _list({
    required String userId,
    required String query,
  }) async {
    final org = await _activeConfig();
    if (org == null) return const [];
    final userSettings = await _credentials.getUserSettings(
      userId: userId,
      providerId: 'figma',
    );
    final merged = _credentials.overlay(
      orgSettings: org.settings,
      userSettings: userSettings,
    );
    final token = extractProviderToken('figma', merged);
    if (token.isEmpty) return const [];

    final pastedKey = extractFigmaFileKey(query);
    if (pastedKey != null) {
      final metaName = await _fileName(pastedKey, token);
      return [
        FollowCandidate(
          providerId: 'figma',
          objectKey: pastedKey,
          title: metaName ?? pastedKey,
          url: figmaFileUrl(pastedKey),
          kind: 'file',
        ),
      ];
    }

    final q = query.toLowerCase();
    final files = <FollowCandidate>[];
    final seen = <String>{};
    final allowKeys = parseFigmaFileKeys(
      org.settings['fileKeys'] ?? userSettings?['fileKeys'],
    );
    if (allowKeys.isNotEmpty) {
      for (final key in allowKeys) {
        if (!key.toLowerCase().contains(q)) continue;
        if (!seen.add(key)) continue;
        files.add(
          FollowCandidate(
            providerId: 'figma',
            objectKey: key,
            title: key,
            url: figmaFileUrl(key),
            kind: 'file',
          ),
        );
      }
      return files;
    }

    final teamIds = parseFigmaTeamIds(
      org.settings['teamIds'] ?? org.settings['teamId'],
    );
    for (final teamId in teamIds) {
      final listed = await _filesForTeam(teamId, token);
      for (final file in listed) {
        final haystack = '${file.key} ${file.name}'.toLowerCase();
        if (!haystack.contains(q)) continue;
        if (!seen.add(file.key)) continue;
        files.add(
          FollowCandidate(
            providerId: 'figma',
            objectKey: file.key,
            title: file.name,
            url: figmaFileUrl(file.key),
            kind: 'file',
          ),
        );
        if (files.length >= 25) return files;
      }
    }
    return files;
  }

  Future<String?> _fileName(String fileKey, String token) async {
    try {
      final body = await _jsonRest.getJsonMap(
        Uri.parse('$kFigmaApiBase/v1/files/${fileKey.trim()}/meta'),
        headers: figmaAuthHeaders(token),
      );
      final fields = figmaFileMetaFields(body);
      final title = figmaFileTitle(
        name: (fields['name'] ?? '').toString(),
        folderName: (fields['folder_name'] ?? '').toString(),
        fileKey: fileKey,
      );
      return title.isEmpty ? null : title;
    } catch (_) {
      return null;
    }
  }

  Future<List<({String key, String name})>> _filesForTeam(
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
      final out = <({String key, String name})>[];
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
          out.add((key: key, name: name));
        }
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  Future<ProviderConfig?> _activeConfig() async {
    final configs = (await _configs.getConfigs()).getOrElse((_) => const []);
    for (final c in configs) {
      if (c.id == 'figma' && c.isActive) return c;
    }
    return null;
  }
}
