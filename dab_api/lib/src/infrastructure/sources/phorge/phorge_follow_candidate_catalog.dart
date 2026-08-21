import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/phorge_scope.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_follow_candidate_catalog.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../protocols/conduit/conduit_protocol.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists Phorge tasks for the Follow picker. Read-only.
/// CONTRACT: Empty [query] is involved (assigned/authored/subscribed). A typed
/// query searches any Maniphest task by id (`T12`) or text.
class PhorgeFollowCandidateCatalog implements AbsIFollowCandidateCatalog {
  PhorgeFollowCandidateCatalog(
    this._configs,
    this._credentials,
    this._users,
    this._conduit,
  );

  final AbsIProviderConfigRepository _configs;
  final AbsICredentialResolver _credentials;
  final IUserRepository _users;
  final ConduitProtocol _conduit;

  @override
  String get providerId => 'phorge';

  @override
  Future<Either<Failure, List<FollowCandidate>>> list({
    required String userId,
    required String query,
  }) async {
    try {
      return Right(await _list(userId: userId, query: query));
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
      providerId: 'phorge',
    );
    final merged = _credentials.overlay(
      orgSettings: org.settings,
      userSettings: userSettings,
    );
    final token = merged.extractProviderToken('phorge');
    if (token.isEmpty) return const [];

    final q = query.trim();
    final browseOrigin = phorgeInstanceUrl(
      instanceUrl: (merged['instanceUrl'] ?? '').toString(),
      baseUrl: org.baseUrl,
    );
    if (q.isNotEmpty) {
      return _searchByQuery(token: token, browseOrigin: browseOrigin, query: q);
    }

    final phid = await _resolvePhid(userId: userId, token: token);
    if (phid.isEmpty) return const [];
    final assigned = await _searchOpenOrAny(
      token: token,
      browseOrigin: browseOrigin,
      ownerConstraint: {
        'assigned': [phid],
      },
      query: q,
    );
    final authored = await _searchOpenOrAny(
      token: token,
      browseOrigin: browseOrigin,
      ownerConstraint: {
        'authorPHIDs': [phid],
      },
      query: q,
    );
    final subscribed = await _searchOpenOrAny(
      token: token,
      browseOrigin: browseOrigin,
      ownerConstraint: {
        'subscriberPHIDs': [phid],
      },
      query: q,
    );
    final seen = <String>{};
    final out = <FollowCandidate>[];
    for (final row in [...assigned, ...authored, ...subscribed]) {
      if (!seen.add(row.objectKey)) continue;
      out.add(row);
    }
    return out;
  }

  Future<String> _resolvePhid({
    required String userId,
    required String token,
  }) async {
    final userResult = await _users.getUser(userId);
    if (userResult.isRight()) {
      final fromUser =
          userResult
              .getOrElse((_) => throw StateError('user'))
              .phorgePhid
              ?.trim() ??
          '';
      if (fromUser.isNotEmpty) return fromUser;
    }

    final identitiesResult = await _users.getIdentities(userId);
    final identities = identitiesResult.getOrElse((_) => const []);
    for (final identity in identities) {
      final provider = identity.providerId.trim().toLowerCase();
      if (provider != 'phorge' && provider != 'phabricator') continue;
      if (identity.status != UserIdentityStatus.linked) continue;
      final id = identity.externalId.trim();
      if (id.startsWith('PHID-')) return id;
    }

    try {
      final result = await _conduit.call('user.whoami', {}, apiToken: token);
      return _phidFromWhoami(result);
    } catch (_) {
      return '';
    }
  }

  String _phidFromWhoami(Map<String, dynamic> result) {
    final phid = (result['phid'] ?? result['userPHID'] ?? '').toString().trim();
    if (phid.isNotEmpty) return phid;
    final nested = result['result'];
    if (nested is Map) {
      return (nested['phid'] ?? '').toString().trim();
    }
    return '';
  }

  static final _taskId = RegExp(r'^T?(\d+)$', caseSensitive: false);

  Future<List<FollowCandidate>> _searchByQuery({
    required String token,
    required String? browseOrigin,
    required String query,
  }) async {
    final idMatch = _taskId.firstMatch(query);
    if (idMatch != null) {
      return _searchSafe(
        token: token,
        browseOrigin: browseOrigin,
        constraints: {
          'ids': [int.parse(idMatch.group(1)!)],
        },
      );
    }
    final open = await _searchSafe(
      token: token,
      browseOrigin: browseOrigin,
      constraints: {
        'statuses': ['open'],
        'query': query,
      },
    );
    if (open.isNotEmpty) return open;
    return _searchSafe(
      token: token,
      browseOrigin: browseOrigin,
      constraints: {'query': query},
    );
  }

  Future<List<FollowCandidate>> _searchOpenOrAny({
    required String token,
    required String? browseOrigin,
    required Map<String, dynamic> ownerConstraint,
    required String query,
  }) async {
    final q = query.trim();
    final open = await _searchSafe(
      token: token,
      browseOrigin: browseOrigin,
      constraints: {
        ...ownerConstraint,
        'statuses': ['open'],
        if (q.isNotEmpty) 'query': q,
      },
    );
    if (open.isNotEmpty) return open;
    return _searchSafe(
      token: token,
      browseOrigin: browseOrigin,
      constraints: {...ownerConstraint, if (q.isNotEmpty) 'query': q},
    );
  }

  Future<List<FollowCandidate>> _searchSafe({
    required String token,
    required String? browseOrigin,
    required Map<String, dynamic> constraints,
  }) async {
    try {
      return await _search(
        token: token,
        browseOrigin: browseOrigin,
        constraints: constraints,
      );
    } catch (_) {
      return const [];
    }
  }

  Future<List<FollowCandidate>> _search({
    required String token,
    required String? browseOrigin,
    required Map<String, dynamic> constraints,
  }) async {
    final result = await _conduit.call('maniphest.search', {
      'constraints': constraints,
      'limit': 25,
    }, apiToken: token);
    final data = result['data'];
    if (data is! List) return const [];
    final out = <FollowCandidate>[];
    for (final item in data) {
      if (item is! Map) continue;
      final phid = (item['phid'] ?? '').toString().trim();
      if (phid.isEmpty) continue;
      final fields = item['fields'];
      final name = fields is Map
          ? (fields['name'] ?? fields['title'] ?? '').toString().trim()
          : '';
      final id = item['id']?.toString() ?? '';
      final label = id.isEmpty
          ? name
          : (name.isEmpty ? 'T$id' : '[T$id] $name');
      final uri = fields is Map ? (fields['uri'] ?? '').toString().trim() : '';
      final browse = id.isEmpty || browseOrigin == null
          ? null
          : '$browseOrigin/T$id';
      out.add(
        FollowCandidate(
          providerId: 'phorge',
          objectKey: phid,
          title: label.isEmpty ? phid : label,
          url: uri.isEmpty ? browse : uri,
        ),
      );
    }
    return out;
  }

  Future<ProviderConfig?> _activeConfig() async {
    final configs = (await _configs.getConfigs()).getOrElse((_) => const []);
    for (final c in configs) {
      if (c.id == 'phorge' && c.isActive) return c;
    }
    return null;
  }
}
