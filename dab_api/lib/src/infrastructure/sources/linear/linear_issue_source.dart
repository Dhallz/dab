import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
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
    implements IActivitySource<LinearIssueDto>, IDiscoverySource {
  LinearIssueSource(
    this._configRepository,
    this._userRepository,
    this._graphql,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final GraphqlProtocol _graphql;

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

    final apiKey = _apiKey(cfg.settings);
    if (apiKey.isEmpty) return const [];

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'linear');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) return const [];

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
    final filter = {
      'updatedAt': {
        'gte': start.toUtc().toIso8601String(),
        'lte': end.toUtc().toIso8601String(),
      },
      ...attributionFilter,
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

    return results;
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
      (settings['apiKey'] ?? settings['api.key'] ?? settings['token'] ?? '')
          .toString()
          .trim();

  Uri _endpoint(Map<String, dynamic> settings) {
    final raw = (settings['apiBaseUrl'] ?? '').toString().trim();
    return Uri.parse(raw.isEmpty ? _defaultEndpoint : raw);
  }
}

/// Maps one GraphQL/webhook issue node into a [LinearIssueDto].
///
/// Returns null when the node lacks an identifier or a parseable `updatedAt`.
/// [externalToUser] maps Linear user UUIDs to DAB user ids; assignee wins over
/// creator for attribution.
LinearIssueDto? mapLinearIssueNode(
  Map<String, dynamic> node,
  Map<String, String> externalToUser,
) {
  final identifier = (node['identifier'] ?? '').toString().trim();
  if (identifier.isEmpty) return null;

  final updatedRaw = node['updatedAt']?.toString();
  final updatedAt = updatedRaw != null
      ? DateTime.tryParse(updatedRaw)?.toUtc()
      : null;
  if (updatedAt == null) return null;

  final team = node['team'];
  var teamKey = team is Map<String, dynamic>
      ? (team['key'] ?? '').toString().trim()
      : '';
  if (teamKey.isEmpty && identifier.contains('-')) {
    teamKey = identifier.split('-').first;
  }

  final state = node['state'];
  final statusName = state is Map<String, dynamic>
      ? (state['name'] ?? '').toString().trim()
      : '';

  final assignee = node['assignee'];
  final creator = node['creator'];
  final assigneeId = linearPersonId(assignee);
  final creatorId = linearPersonId(creator);

  String? dabUserId;
  for (final externalId in [assigneeId, creatorId]) {
    if (externalId == null) continue;
    final mapped = externalToUser[externalId];
    if (mapped != null && mapped.isNotEmpty) {
      dabUserId = mapped;
      break;
    }
  }

  return LinearIssueDto(
    identifier: identifier,
    teamKey: teamKey.isEmpty ? 'UNKNOWN' : teamKey,
    title: (node['title'] ?? '').toString(),
    statusName: statusName,
    url: (node['url'] ?? '').toString().trim(),
    updatedAt: updatedAt,
    dabUserId: dabUserId,
    authorDisplayName:
        linearPersonDisplay(assignee) ?? linearPersonDisplay(creator),
  );
}

/// Extracts a Linear user UUID from an embedded person node.
String? linearPersonId(Object? person) {
  if (person is! Map<String, dynamic>) return null;
  final raw = person['id']?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return raw;
}

/// Extracts a display label from an embedded person node.
String? linearPersonDisplay(Object? person) {
  if (person is! Map<String, dynamic>) return null;
  final display =
      (person['displayName'] ?? person['name'])?.toString().trim();
  if (display == null || display.isEmpty) return null;
  return display;
}
