import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures/failure.dart';
import '../../domain/core/gitlab_scope.dart';
import '../../domain/core/provider_credential_keys.dart';
import '../../domain/entities/user/provider_whoami_result.dart';
import '../../domain/entities/provider/provider_config.dart';
import '../../domain/ports/i_provider_identity_probe.dart';
import '../protocols/conduit/conduit_protocol.dart';
import '../protocols/graphql/graphql_protocol.dart';
import '../protocols/rest/json_rest_protocol.dart';
import '../protocols/slack/slack_web_protocol.dart';
import '../sources/bitbucket/bitbucket_commit_source.dart';
import '../sources/gitlab/gitlab_commit_source.dart';
import '../sources/jira/jira_jql.dart';
import '../sources/jira/jira_project_catalog.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Validates provider credentials via whoami and optional watch-list discovery.
/// CONSTRAINTS: Read-only. Never logs tokens.
class ProviderIdentityProbe implements IProviderIdentityProbe {
  ProviderIdentityProbe({
    required JsonRestProtocol jsonRest,
    required GraphqlProtocol graphql,
    required SlackWebProtocol slackWeb,
    required ConduitProtocol conduit,
  }) : _jsonRest = jsonRest,
       _graphql = graphql,
       _slackWeb = slackWeb,
       _conduit = conduit;

  final JsonRestProtocol _jsonRest;
  final GraphqlProtocol _graphql;
  final SlackWebProtocol _slackWeb;
  final ConduitProtocol _conduit;

  @override
  Future<Either<Failure, ProviderWhoamiResult>> probe({
    required String providerId,
    required Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (!hasRequiredProviderSecrets(id, settings)) {
      return const Left(
        ValidationFailure('Missing required credentials for this provider'),
      );
    }
    try {
      switch (id) {
        case 'github':
          return Right(await _github(settings));
        case 'gitlab':
          return Right(await _gitlab(settings, orgConfig));
        case 'bitbucket':
          return Right(await _bitbucket(settings));
        case 'jira':
          return Right(await _jira(settings, orgConfig));
        case 'linear':
          return Right(await _linear(settings));
        case 'phorge':
          return Right(await _phorge(settings, orgConfig));
        case 'slack':
          return Right(await _slack(settings));
        case 'discord':
          return Right(await _discord(settings));
        default:
          return const Left(ValidationFailure('Unknown provider'));
      }
    } catch (e) {
      return Left(ValidationFailure('Could not verify credentials: $e'));
    }
  }

  Future<ProviderWhoamiResult> _github(Map<String, dynamic> settings) async {
    final token = extractProviderToken('github', settings);
    final apiBase = _trimSlash(
      (settings['apiBaseUrl'] ?? '').toString().trim().isEmpty
          ? 'https://api.github.com'
          : settings['apiBaseUrl'].toString().trim(),
    );
    final headers = {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'dab-api',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    final user = await _jsonRest.getJsonMap(
      Uri.parse('$apiBase/user'),
      headers: headers,
    );
    final login = (user['login'] ?? '').toString().trim();
    if (login.isEmpty) {
      throw StateError('GitHub whoami returned no login');
    }
    final repos = <String>[];
    try {
      final list = await _jsonRest.getJsonList(
        Uri.parse('$apiBase/user/repos').replace(
          queryParameters: {
            'per_page': '100',
            'sort': 'updated',
            'affiliation': 'owner,collaborator,organization_member',
          },
        ),
        headers: headers,
      );
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final name = (raw['full_name'] ?? '').toString().trim();
        if (name.contains('/')) repos.add(name);
      }
    } catch (_) {
      // Watch-list discovery is best-effort.
    }
    return ProviderWhoamiResult(
      externalId: login,
      externalUsername: login,
      discoveredWatchList: repos,
    );
  }

  Future<ProviderWhoamiResult> _gitlab(
    Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  ) async {
    final apiBase = gitLabApiBase(settings, orgConfig?.baseUrl ?? '');
    final headers = gitLabAuthHeaders(settings);
    final user = await _jsonRest.getJsonMap(
      Uri.parse('$apiBase/user'),
      headers: headers,
    );
    final username = (user['username'] ?? '').toString().trim();
    if (username.isEmpty) {
      throw StateError('GitLab whoami returned no username');
    }
    final projects = <String>[];
    try {
      final list = await _jsonRest.getJsonList(
        Uri.parse('$apiBase/projects').replace(
          queryParameters: {
            'membership': 'true',
            'simple': 'true',
            'per_page': '50',
            'order_by': 'last_activity_at',
          },
        ),
        headers: headers,
      );
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final path = (raw['path_with_namespace'] ?? '').toString().trim();
        if (path.isNotEmpty) projects.add(path);
      }
    } catch (_) {}
    return ProviderWhoamiResult(
      externalId: username,
      externalUsername: username,
      discoveredWatchList: projects,
    );
  }

  Future<ProviderWhoamiResult> _bitbucket(Map<String, dynamic> settings) async {
    final headers = bitbucketAuthHeaders(settings);
    if (headers == null) {
      throw StateError('Bitbucket credentials are incomplete');
    }
    final user = await _jsonRest.getJsonMap(
      Uri.parse('https://api.bitbucket.org/2.0/user'),
      headers: headers,
    );
    final accountId = (user['account_id'] ?? user['uuid'] ?? '')
        .toString()
        .trim();
    final display = (user['display_name'] ?? user['username'] ?? '')
        .toString()
        .trim();
    if (accountId.isEmpty) {
      throw StateError('Bitbucket whoami returned no account id');
    }
    final repos = <String>[];
    try {
      final body = await _jsonRest.getJsonMap(
        Uri.parse(
          'https://api.bitbucket.org/2.0/repositories?role=member&pagelen=50',
        ),
        headers: headers,
      );
      final values = body['values'];
      if (values is List) {
        for (final raw in values) {
          if (raw is! Map<String, dynamic>) continue;
          final full = (raw['full_name'] ?? '').toString().trim();
          if (full.contains('/')) repos.add(full);
        }
      }
    } catch (_) {}
    return ProviderWhoamiResult(
      externalId: accountId,
      externalUsername: display.isEmpty ? accountId : display,
      discoveredWatchList: repos,
    );
  }

  Future<ProviderWhoamiResult> _jira(
    Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  ) async {
    final auth = jiraRequestAuth(settings, orgConfig: orgConfig);
    if (auth == null) {
      throw StateError('Jira credentials are incomplete');
    }
    final me = await _jsonRest.getJsonMap(
      Uri.parse('${auth.apiBase}/rest/api/3/myself'),
      headers: auth.headers,
    );
    final accountId = (me['accountId'] ?? '').toString().trim();
    if (accountId.isEmpty) {
      throw StateError('Jira myself returned no accountId');
    }
    final projects = <String>[];
    try {
      final list = await listJiraProjectRows(_jsonRest, auth);
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final key = (raw['key'] ?? '').toString().trim();
        if (key.isNotEmpty) projects.add(key);
      }
    } catch (_) {}
    return ProviderWhoamiResult(
      externalId: accountId,
      externalUsername: (me['displayName'] ?? '').toString().trim(),
      discoveredWatchList: projects,
    );
  }

  Future<ProviderWhoamiResult> _linear(Map<String, dynamic> settings) async {
    final apiKey = extractProviderToken('linear', settings);
    final raw = (settings['apiBaseUrl'] ?? '').toString().trim();
    final endpoint = Uri.parse(
      raw.isEmpty ? 'https://api.linear.app/graphql' : raw,
    );
    final data = await _graphql.execute(
      endpoint,
      bearerToken: apiKey,
      document: 'query { viewer { id displayName } }',
    );
    final viewer = data['viewer'];
    if (viewer is! Map<String, dynamic>) {
      throw StateError('Linear viewer missing');
    }
    final id = (viewer['id'] ?? '').toString().trim();
    if (id.isEmpty) throw StateError('Linear viewer has no id');
    return ProviderWhoamiResult(
      externalId: id,
      externalUsername: (viewer['displayName'] ?? '').toString().trim(),
    );
  }

  Future<ProviderWhoamiResult> _phorge(
    Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  ) async {
    final token = extractProviderToken('phorge', settings);
    final result = await _conduit.call('user.whoami', {}, apiToken: token);
    final phid = (result['phid'] ?? result['userPHID'] ?? '').toString().trim();
    if (phid.isEmpty) {
      final nested = result['result'];
      if (nested is Map<String, dynamic>) {
        final nestedPhid = (nested['phid'] ?? '').toString().trim();
        if (nestedPhid.isNotEmpty) {
          return ProviderWhoamiResult(
            externalId: nestedPhid,
            externalUsername: (nested['userName'] ?? nested['username'] ?? '')
                .toString()
                .trim(),
          );
        }
      }
      throw StateError('Phorge whoami returned no PHID');
    }
    return ProviderWhoamiResult(
      externalId: phid,
      externalUsername: (result['userName'] ?? result['username'] ?? '')
          .toString()
          .trim(),
    );
  }

  Future<ProviderWhoamiResult> _slack(Map<String, dynamic> settings) async {
    final token = extractProviderToken('slack', settings);
    final apiBase = _trimSlash(
      (settings['apiBaseUrl'] ?? '').toString().trim().isEmpty
          ? 'https://slack.com/api'
          : settings['apiBaseUrl'].toString().trim(),
    );
    final body = await _slackWeb.postJson(
      Uri.parse('$apiBase/auth.test'),
      bearerToken: token,
    );
    final userId = (body['user_id'] ?? '').toString().trim();
    if (userId.isEmpty) {
      throw StateError('Slack auth.test returned no user_id');
    }
    return ProviderWhoamiResult(
      externalId: userId,
      externalUsername: (body['user'] ?? body['team'] ?? '').toString().trim(),
    );
  }

  Future<ProviderWhoamiResult> _discord(Map<String, dynamic> settings) async {
    final token = extractProviderToken('discord', settings);
    final me = await _jsonRest.getJsonMap(
      Uri.parse('https://discord.com/api/v10/users/@me'),
      headers: {'Authorization': 'Bot $token', 'Accept': 'application/json'},
    );
    final id = (me['id'] ?? '').toString().trim();
    if (id.isEmpty) throw StateError('Discord @me returned no id');
    return ProviderWhoamiResult(
      externalId: id,
      externalUsername: (me['username'] ?? '').toString().trim(),
    );
  }

  String _trimSlash(String value) => value.replaceAll(RegExp(r'/+$'), '');
}
