import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';
import 'package:dab_api/src/domain/dtos/linear/linear_issue_mapping.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/linear_team_watch_list.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_discovery_source.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only Linear issue retrieval via the Linear GraphQL API.
/// CONTRACT: Returns [LinearIssueDto] rows for [UnifiedActivityFetcher];
/// attribution is identity-based (`provider_id: linear` linked rows, external
/// id = Linear user UUID). Auth: personal API key (`apiKey` setting) sent as
/// bearer token.
/// CONSTRAINTS: Must be READ-ONLY; no mutations are ever issued.
class LinearIssueSource
    implements AbsIActivitySource<LinearIssueDto>, AbsIDiscoverySource {
  LinearIssueSource(
    this._configRepository,
    this._userRepository,
    this._graphql,
    this._credentials,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final GraphqlProtocol _graphql;
  final AbsICredentialResolver _credentials;

  static const _defaultEndpoint = 'https://api.linear.app/graphql';

  static const _issuesQuery = '''
query DabIssues(\$filter: IssueFilter, \$first: Int!, \$after: String) {
  issues(filter: \$filter, first: \$first, after: \$after) {
    nodes {
      identifier
      title
      url
      updatedAt
      state { name }
      team { key }
      assignee { id name displayName }
      creator { id name displayName }
    }
    pageInfo { hasNextPage endCursor }
  }
}
''';

  static const _commentsQuery = '''
query DabComments(\$filter: CommentFilter, \$first: Int!, \$after: String) {
  comments(filter: \$filter, first: \$first, after: \$after) {
    nodes {
      id
      body
      createdAt
      user { id name displayName }
      issue {
        identifier
        title
        url
        updatedAt
        state { name }
        team { key }
        assignee { id name displayName }
        creator { id name displayName }
      }
    }
    pageInfo { hasNextPage endCursor }
  }
}
''';

  static const _userLookupQuery = '''
query DabUserLookup(\$filter: UserFilter) {
  users(filter: \$filter, first: 1) {
    nodes { id }
  }
}
''';

  @override
  Future<List<LinearIssueDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeLinearConfig();
    if (cfg == null) return const [];

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'linear');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) return const [];

    final userSettings = await _credentials.getUserSettingsForUsers(
      userIds: linkedIdentities.map((i) => i.userId),
      providerId: 'linear',
    );
    final orgKey = _apiKey(cfg.settings);

    Future<List<LinearIssueDto>> fetchWith({
      required String apiKey,
      required List<String> identityIds,
    }) {
      return _fetchIssues(
        cfg: cfg,
        apiKey: apiKey,
        start: start,
        end: end,
        authoredOnly: authoredOnly,
        linkedIdentities: linkedIdentities
            .where((i) => identityIds.contains(i.externalId))
            .toList(),
      );
    }

    if (orgKey.isNotEmpty) {
      return fetchWith(
        apiKey: orgKey,
        identityIds: linkedIdentities.map((i) => i.externalId).toList(),
      );
    }

    final results = <LinearIssueDto>[];
    final seen = <String>{};
    for (final identity in linkedIdentities) {
      final merged = _credentials.overlay(
        orgSettings: cfg.settings,
        userSettings: userSettings[identity.userId],
      );
      final key = _apiKey(merged);
      if (key.isEmpty) continue;
      final rows = await fetchWith(
        apiKey: key,
        identityIds: [identity.externalId],
      );
      for (final row in rows) {
        if (seen.add(row.identifier)) results.add(row);
      }
    }
    return results;
  }

  Future<List<LinearIssueDto>> _fetchIssues({
    required ProviderConfig cfg,
    required String apiKey,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
    required List<UserIdentity> linkedIdentities,
  }) async {
    if (apiKey.isEmpty || linkedIdentities.isEmpty) return const [];

    final externalToUser = {
      for (final i in linkedIdentities) i.externalId: i.userId,
    };
    final externalIds = externalToUser.keys.toList();

    final attributionFilter = authoredOnly
        ? {
            'creator': {
              'id': {'in': externalIds},
            },
          }
        : {
            'or': [
              {
                'assignee': {
                  'id': {'in': externalIds},
                },
              },
              {
                'creator': {
                  'id': {'in': externalIds},
                },
              },
            ],
          };
    final teamKeys = parseLinearTeamKeys(cfg.settings['teamKeys']);
    final filter = <String, dynamic>{
      'updatedAt': {
        'gte': start.toUtc().toIso8601String(),
        'lte': end.toUtc().toIso8601String(),
      },
      ...attributionFilter,
      if (teamKeys.isNotEmpty)
        'team': {
          'key': {'in': teamKeys},
        },
    };

    final endpoint = _endpoint(cfg.settings);
    final results = <LinearIssueDto>[];
    final seen = <String>{};
    String? after;

    for (var page = 0; page < 20; page++) {
      Map<String, dynamic> data;
      try {
        data = await _graphql.execute(
          endpoint,
          bearerToken: apiKey,
          document: _issuesQuery,
          variables: {'filter': filter, 'first': 50, 'after': ?after},
        );
      } catch (_) {
        break;
      }

      final issues = data['issues'];
      if (issues is! Map<String, dynamic>) break;
      final nodes = issues['nodes'];
      if (nodes is! List) break;

      for (final node in nodes) {
        if (node is! Map<String, dynamic>) continue;
        final dto = mapLinearIssueNode(node, externalToUser);
        if (dto == null) continue;
        if (!seen.add(dto.identifier)) continue;
        results.add(dto);
      }

      final pageInfo = issues['pageInfo'];
      if (pageInfo is! Map<String, dynamic> ||
          pageInfo['hasNextPage'] != true) {
        break;
      }
      after = pageInfo['endCursor']?.toString();
      if (after == null || after.isEmpty) break;
    }

    final commentsByIssue = await _fetchComments(
      endpoint: endpoint,
      apiKey: apiKey,
      start: start,
      end: end,
      externalToUser: externalToUser,
      teamKeys: teamKeys,
    );
    return _mergeComments(results, commentsByIssue, externalToUser);
  }

  /// Comments in [start]–[end] whose author or parent issue maps to a linked
  /// Linear identity. Failures are swallowed so issue polling still returns.
  Future<Map<String, _LinearIssueComments>> _fetchComments({
    required Uri endpoint,
    required String apiKey,
    required DateTime start,
    required DateTime end,
    required Map<String, String> externalToUser,
    required List<String> teamKeys,
  }) async {
    final externalIds = externalToUser.keys.toList();
    final filter = {
      'updatedAt': {
        'gte': start.toUtc().toIso8601String(),
        'lte': end.toUtc().toIso8601String(),
      },
      'or': [
        {
          'user': {
            'id': {'in': externalIds},
          },
        },
        {
          'issue': {
            'assignee': {
              'id': {'in': externalIds},
            },
          },
        },
        {
          'issue': {
            'creator': {
              'id': {'in': externalIds},
            },
          },
        },
      ],
    };

    final byIssue = <String, _LinearIssueComments>{};
    String? after;
    for (var page = 0; page < 20; page++) {
      Map<String, dynamic> data;
      try {
        data = await _graphql.execute(
          endpoint,
          bearerToken: apiKey,
          document: _commentsQuery,
          variables: {'filter': filter, 'first': 50, 'after': ?after},
        );
      } catch (_) {
        break;
      }

      final comments = data['comments'];
      if (comments is! Map<String, dynamic>) break;
      final nodes = comments['nodes'];
      if (nodes is! List) break;

      for (final node in nodes) {
        if (node is! Map<String, dynamic>) continue;
        final issueRaw = node['issue'];
        if (issueRaw is! Map<String, dynamic>) continue;
        final identifier = (issueRaw['identifier'] ?? '').toString().trim();
        if (identifier.isEmpty) continue;
        if (teamKeys.isNotEmpty) {
          final team = issueRaw['team'];
          var teamKey = team is Map<String, dynamic>
              ? (team['key'] ?? '').toString().trim()
              : '';
          if (teamKey.isEmpty && identifier.contains('-')) {
            teamKey = identifier.split('-').first;
          }
          if (!teamKeys.contains(teamKey)) continue;
        }
        final comment = mapLinearCommentNode(node, externalToUser);
        if (comment == null) continue;
        final bucket = byIssue.putIfAbsent(
          identifier,
          () => _LinearIssueComments(issue: issueRaw, comments: []),
        );
        bucket.comments.add(comment);
      }

      final pageInfo = comments['pageInfo'];
      if (pageInfo is! Map<String, dynamic> ||
          pageInfo['hasNextPage'] != true) {
        break;
      }
      after = pageInfo['endCursor']?.toString();
      if (after == null || after.isEmpty) break;
    }
    return byIssue;
  }

  List<LinearIssueDto> _mergeComments(
    List<LinearIssueDto> issues,
    Map<String, _LinearIssueComments> commentsByIssue,
    Map<String, String> externalToUser,
  ) {
    if (commentsByIssue.isEmpty) return issues;

    final merged = <LinearIssueDto>[];
    final seen = <String>{};
    for (final issue in issues) {
      seen.add(issue.identifier);
      final extra = commentsByIssue[issue.identifier];
      if (extra == null || extra.comments.isEmpty) {
        merged.add(issue);
        continue;
      }
      merged.add(issue.copyWith(comments: extra.comments));
    }
    for (final entry in commentsByIssue.entries) {
      if (seen.contains(entry.key)) continue;
      final dto = mapLinearIssueNode(entry.value.issue, externalToUser);
      if (dto == null) continue;
      merged.add(dto.copyWith(comments: entry.value.comments));
    }
    return merged;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    final cfg = await _activeLinearConfig();
    if (cfg == null) return const Right(null);

    final apiKey = _apiKey(cfg.settings);
    if (apiKey.isEmpty) return const Right(null);

    final query = email.trim();
    if (query.isEmpty) return const Right(null);

    try {
      final data = await _graphql.execute(
        _endpoint(cfg.settings),
        bearerToken: apiKey,
        document: _userLookupQuery,
        variables: {
          'filter': {
            'email': {'eq': query},
          },
        },
      );
      final usersNode = data['users'];
      if (usersNode is! Map<String, dynamic>) return const Right(null);
      final nodes = usersNode['nodes'];
      if (nodes is! List || nodes.isEmpty) return const Right(null);
      final first = nodes.first;
      if (first is! Map<String, dynamic>) return const Right(null);
      final id = first['id']?.toString().trim();
      if (id == null || id.isEmpty) return const Right(null);
      return Right(id);
    } catch (_) {
      return const Right(null);
    }
  }

  Future<ProviderConfig?> _activeLinearConfig() async {
    final configsResult = await _configRepository.getConfigs();
    final configs = configsResult.getOrElse((_) => <ProviderConfig>[]);
    for (final c in configs) {
      if (c.id == 'linear' && c.isActive) return c;
    }
    return null;
  }

  String _apiKey(Map<String, dynamic> settings) =>
      extractProviderToken('linear', settings);

  Uri _endpoint(Map<String, dynamic> settings) {
    final raw = (settings['apiBaseUrl'] ?? '').toString().trim();
    return Uri.parse(raw.isEmpty ? _defaultEndpoint : raw);
  }
}

class _LinearIssueComments {
  _LinearIssueComments({required this.issue, required this.comments});

  final Map<String, dynamic> issue;
  final List<LinearIssueCommentDto> comments;
}
