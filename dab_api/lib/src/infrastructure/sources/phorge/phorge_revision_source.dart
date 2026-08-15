import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/contracts/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/ports/i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for Phorge Differential Revisions (Code Reviews).
/// CONTRACT: Implements [IActivitySource] for [PhorgeRevisionDto].
/// CONSTRAINTS: Must be READ-ONLY. Logic is restricted to API coordination and DTO mapping.
///
/// This source handles binary protocol communication with Phorge to retrieve
/// Differential Revisions (D-numbers) within specific time bounds.
class PhorgeRevisionSource implements IActivitySource<PhorgeRevisionDto> {
  final ConduitProtocol _client;
  final ICredentialResolver _credentials;
  final AbsIProviderConfigRepository _configs;

  PhorgeRevisionSource(
    this._client, {
    required ICredentialResolver credentials,
    required AbsIProviderConfigRepository configs,
  }) : _credentials = credentials,
       _configs = configs;

  String? _activeToken;

  Future<Map<String, dynamic>> _conduitCall(
    String method,
    Map<String, dynamic> params,
  ) {
    return _client.call(method, params, apiToken: _activeToken);
  }

  @override
  /// [ARCH: INFRASTRUCTURE_ENTRY]
  /// ROLE: Entry point for fetching Phorge Revision data.
  /// CONTRACT: Performs `differential.revision.search` with optional author filtering.
  Future<List<PhorgeRevisionDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final userPhids = users
        .map((u) => u.phorgePhid?.trim())
        .whereType<String>()
        .where((phid) => phid.isNotEmpty)
        .toSet()
        .toList();
    if (authoredOnly && userPhids.isEmpty) {
      return [];
    }

    _activeToken = await _resolvePersonalToken(users);
    try {
      final result = await _conduitCall('differential.revision.search', {
        'constraints': {
          if (authoredOnly && userPhids.isNotEmpty) 'authorPHIDs': userPhids,
          'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
          'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
        },
      });

      final rawData = result['data'] as List<dynamic>?;
      if (rawData == null) return [];

      return rawData
          .map(
            (e) => PhorgeRevisionDtoMapper.fromMap(e as Map<String, dynamic>),
          )
          .toList();
    } finally {
      _activeToken = null;
    }
  }

  Future<String?> _resolvePersonalToken(List<User> users) async {
    final all = (await _configs.getConfigs()).getOrElse((_) => []);
    final org = all.where((c) => c.id == 'phorge').firstOrNull;
    final orgSettings = org?.settings ?? const <String, dynamic>{};
    var token = extractProviderToken('phorge', orgSettings);
    if (token.isNotEmpty) return token;
    final userSettings = await _credentials.getUserSettingsForUsers(
      userIds: users.map((u) => u.id),
      providerId: 'phorge',
    );
    for (final user in users) {
      final merged = _credentials.overlay(
        orgSettings: orgSettings,
        userSettings: userSettings[user.id],
      );
      token = extractProviderToken('phorge', merged);
      if (token.isNotEmpty) return token;
    }
    return null;
  }
}
