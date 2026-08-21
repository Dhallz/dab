import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_follow_candidate_catalog.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../protocols/graphql/graphql_protocol.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists Linear issues for the Follow picker. Read-only.
/// CONTRACT: Empty [query] is involved (assignee/creator/subscriber). A typed
/// query searches any issue in the instance [teamKeys] allow-list (or all
/// teams when that list is empty).
class LinearFollowCandidateCatalog implements AbsIFollowCandidateCatalog {
  LinearFollowCandidateCatalog(
    this._configs,
    this._credentials,
    this._graphql,
    this._users,
  );

  final AbsIProviderConfigRepository _configs;
  final AbsICredentialResolver _credentials;
  final GraphqlProtocol _graphql;
  final IUserRepository _users;

  static const _endpoint = 'https://api.linear.app/graphql';
  static const _query = '''
query DabFollowCandidates(\$filter: IssueFilter, \$first: Int!) {
  issues(filter: \$filter, first: \$first) {
    nodes { identifier title url }
  }
}
''';

  @override
  String get providerId => 'linear';

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
      providerId: 'linear',
    );
    final merged = _credentials.overlay(
      orgSettings: org.settings,
      userSettings: userSettings,
    );
    final apiKey = merged.extractProviderToken('linear');
    if (apiKey.isEmpty) return const [];

    final teamKeys = (org.settings['teamKeys'] as Object?).parseLinearTeamKeys();
    final rawEndpoint = (merged['apiBaseUrl'] ?? '').toString().trim();
    final endpoint = Uri.parse(rawEndpoint.isEmpty ? _endpoint : rawEndpoint);
    final q = query.trim();
    if (q.isNotEmpty) {
      final filter = _searchFilter(query: q, teamKeys: teamKeys);
      if (filter == null) return const [];
      try {
        return await _fetch(endpoint: endpoint, apiKey: apiKey, filter: filter);
      } catch (_) {
        return const [];
      }
    }

    final identityId = await _linearExternalId(userId);
    try {
      return await _fetch(
        endpoint: endpoint,
        apiKey: apiKey,
        filter: _involvedIssueFilter(
          identityId: identityId,
          includeSubscribers: true,
          teamKeys: teamKeys,
        ),
      );
    } catch (_) {
      try {
        return await _fetch(
          endpoint: endpoint,
          apiKey: apiKey,
          filter: _involvedIssueFilter(
            identityId: identityId,
            includeSubscribers: false,
            teamKeys: teamKeys,
          ),
        );
      } catch (_) {
        return const [];
      }
    }
  }

  Future<String?> _linearExternalId(String userId) async {
    final result = await _users.getIdentity(userId, 'linear');
    final identity = result.getOrElse((_) => null);
    if (identity == null || identity.status != UserIdentityStatus.linked) {
      return null;
    }
    final id = identity.externalId.trim();
    return id.isEmpty ? null : id;
  }

  static final _issueKey = RegExp(r'^([A-Za-z][A-Za-z0-9_]*)-(\d+)$');

  /// Workspace search: identifier (`ENG-42`) or title, not involvement.
  /// Returns null when [teamKeys] excludes the typed team.
  Map<String, dynamic>? _searchFilter({
    required String query,
    required List<String> teamKeys,
  }) {
    final key = _issueKey.firstMatch(query);
    if (key != null) {
      final team = key.group(1)!;
      if (teamKeys.isNotEmpty && !teamKeys.contains(team)) return null;
      return {
        'team': {
          'key': {'eq': team},
        },
        'number': {'eq': int.parse(key.group(2)!)},
      };
    }
    return {
      if (teamKeys.isNotEmpty)
        'team': {
          'key': {'in': teamKeys},
        },
      'title': {'containsIgnoreCase': query},
    };
  }

  /// Linear [IssueFilter] for issues assigned to, created by, or subscribed by
  /// the caller. Uses the linked Linear user id when present so an org API key
  /// still matches the DAB user (`isMe` would be the key owner instead).
  Map<String, dynamic> _involvedIssueFilter({
    required String? identityId,
    required bool includeSubscribers,
    required List<String> teamKeys,
  }) {
    final involved = _involvedFilter(
      identityId: identityId,
      includeSubscribers: includeSubscribers,
    );
    return <String, dynamic>{
      if (teamKeys.isNotEmpty)
        'team': {
          'key': {'in': teamKeys},
        },
      ...involved,
    };
  }

  Map<String, dynamic> _involvedFilter({
    required String? identityId,
    required bool includeSubscribers,
  }) {
    if (identityId != null) {
      return {
        'or': [
          {
            'assignee': {
              'id': {
                'in': [identityId],
              },
            },
          },
          {
            'creator': {
              'id': {
                'in': [identityId],
              },
            },
          },
          if (includeSubscribers)
            {
              'subscribers': {
                'some': {
                  'id': {'eq': identityId},
                },
              },
            },
        ],
      };
    }
    return includeSubscribers
        ? <String, dynamic>{
            'or': [
              {
                'assignee': {
                  'isMe': {'eq': true},
                },
              },
              {
                'subscribers': {
                  'some': {
                    'isMe': {'eq': true},
                  },
                },
              },
            ],
          }
        : <String, dynamic>{
            'assignee': {
              'isMe': {'eq': true},
            },
          };
  }

  Future<List<FollowCandidate>> _fetch({
    required Uri endpoint,
    required String apiKey,
    required Map<String, dynamic> filter,
  }) async {
    final data = await _graphql.execute(
      endpoint,
      bearerToken: apiKey,
      document: _query,
      variables: {'filter': filter, 'first': 25},
    );
    final issues = data['issues'];
    if (issues is! Map) return const [];
    final nodes = issues['nodes'];
    if (nodes is! List) return const [];
    final out = <FollowCandidate>[];
    for (final node in nodes) {
      if (node is! Map) continue;
      final identifier = (node['identifier'] ?? '').toString().trim();
      if (identifier.isEmpty) continue;
      final title = (node['title'] ?? '').toString().trim();
      out.add(
        FollowCandidate(
          providerId: 'linear',
          objectKey: identifier,
          title: title.isEmpty ? identifier : '[$identifier] $title',
          url: (node['url'] ?? '').toString().trim().isEmpty
              ? null
              : (node['url'] ?? '').toString().trim(),
        ),
      );
    }
    return out;
  }

  Future<ProviderConfig?> _activeConfig() async {
    final configs = (await _configs.getConfigs()).getOrElse((_) => const []);
    for (final c in configs) {
      if (c.id == 'linear' && c.isActive) return c;
    }
    return null;
  }
}
