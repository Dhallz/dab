import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../domain/core/bitbucket_scope.dart';
import '../../domain/core/discord_scope.dart';
import '../../domain/core/failures/failure.dart';
import '../../domain/core/github_scope.dart';
import '../../domain/core/gitlab_scope.dart';
import '../../domain/core/figma_scope.dart';
import '../../domain/core/phorge_scope.dart';
import '../../domain/entities/provider/provider_config.dart';
import '../../domain/entities/provider/provider_connectivity_report.dart';
import '../../infrastructure/protocols/conduit/http_conduit_protocol.dart';
import 'provider_live_connectivity_checker.dart';
import 'provider_live_webhook_test_service.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Runs Core / Live / Polling connectivity probes for provider configs.
/// CONTRACT: Returns structured [ProviderConnectivityReport] for Admin tests.
class ProviderConfigConnectivityService {
  ProviderConfigConnectivityService(
    this._liveChecker,
    this._liveWebhookTester,
  );

  final ProviderLiveConnectivityChecker _liveChecker;
  final ProviderLiveWebhookTestService _liveWebhookTester;

  Future<ProviderSectionResult> _resolveLive(
    ProviderConfig config,
    String providerId,
  ) async {
    final cached = await _liveChecker.check(providerId);
    if (cached.status == ConnectivitySectionStatus.success) {
      return cached;
    }
    return _liveWebhookTester.testDelivery(config);
  }

  Future<Either<Failure, ProviderConnectivityReport>> test(
    ProviderConfig config,
  ) async {
    final id = config.id.trim().toLowerCase();
    return switch (id) {
      'github' => _testGitHub(config),
      'slack' => _testSlack(config),
      'gitlab' => _testGitLab(config),
      'bitbucket' => _testBitbucket(config),
      'jira' => _testJira(config),
      'linear' => _testLinear(config),
      'discord' => _testDiscord(config),
      'phorge' || 'phabricator' => _testPhorge(config),
      'figma' => _testFigma(config),
      _ => _testGeneric(config),
    };
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testGitHub(
    ProviderConfig config,
  ) async {
    final token = _setting(config, ['api.token', 'token']);
    if (token.isEmpty) {
      return Left(ValidationFailure('GitHub token is missing'));
    }

    final apiBaseUrl = _githubApiBase(config.settings);
    final core = await _githubCore(token: token, apiBaseUrl: apiBaseUrl);
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final repos = extractConfiguredGithubRepos(config.settings);
    final polling = await _githubPolling(
      token: token,
      apiBaseUrl: apiBaseUrl,
      repos: repos,
      branch: _setting(config, ['branch']),
    );
    final live = await _resolveLive(config, 'github');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testSlack(
    ProviderConfig config,
  ) async {
    final token = _setting(config, ['botToken', 'api.token', 'token']);
    if (token.isEmpty) {
      return Left(ValidationFailure('Slack bot token is missing'));
    }

    final apiBaseUrl = _slackApiBase(config.settings);
    final core = await _slackCore(token: token, apiBaseUrl: apiBaseUrl);
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final channels = _extractSlackChannels(config.settings);
    final polling = await _slackPolling(
      token: token,
      apiBaseUrl: apiBaseUrl,
      channels: channels,
    );
    final live = await _resolveLive(config, 'slack');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testGitLab(
    ProviderConfig config,
  ) async {
    final token = _setting(config, ['apiToken', 'api.token', 'token']);
    final instanceUrl = _setting(config, ['instanceUrl']).isNotEmpty
        ? _setting(config, ['instanceUrl'])
        : config.baseUrl.trim();
    if (token.isEmpty || instanceUrl.isEmpty) {
      return Left(
        ValidationFailure('GitLab API token and instance URL are required'),
      );
    }

    final normalizedUrl = instanceUrl.replaceAll(RegExp(r'/+$'), '');
    final core = await _gitlabCore(token: token, instanceUrl: normalizedUrl);
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final projects = gitLabProjects(config.settings);
    final apiBase = gitLabApiBase(config.settings, normalizedUrl);
    final polling = await _gitlabPolling(
      token: token,
      apiBase: apiBase,
      projects: projects,
      branch: _setting(config, ['branch']),
    );
    final live = await _resolveLive(config, 'gitlab');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testBitbucket(
    ProviderConfig config,
  ) async {
    final username = _setting(config, ['username']);
    final secret = _setting(config, [
      'apiToken',
      'appPassword',
      'token',
    ]);
    if (username.isEmpty || secret.isEmpty) {
      return Left(
        ValidationFailure('Bitbucket username or app password is missing'),
      );
    }

    final core = await _bitbucketCore(username: username, secret: secret);
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final workspace = bitbucketWorkspace(config.settings);
    final repos = bitbucketRepos(config.settings);
    final polling = await _bitbucketPolling(
      username: username,
      secret: secret,
      workspace: workspace,
      repos: repos,
    );
    final live = await _resolveLive(config, 'bitbucket');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testJira(
    ProviderConfig config,
  ) async {
    final apiToken = _setting(config, ['apiToken', 'api.token', 'token']);
    final email = _setting(config, ['email']);
    final instanceUrl = _setting(config, ['instanceUrl']).isNotEmpty
        ? _setting(config, ['instanceUrl'])
        : config.baseUrl.trim();
    if (apiToken.isEmpty || email.isEmpty || instanceUrl.isEmpty) {
      return Left(
        ValidationFailure(
          'Jira API token, email, and instance URL are required',
        ),
      );
    }

    final normalizedUrl = instanceUrl.replaceAll(RegExp(r'/+$'), '');
    final core = await _jiraCore(
      apiToken: apiToken,
      email: email,
      instanceUrl: normalizedUrl,
    );
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final polling = await _jiraPolling(
      apiToken: apiToken,
      email: email,
      instanceUrl: normalizedUrl,
    );
    final live = await _resolveLive(config, 'jira');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testLinear(
    ProviderConfig config,
  ) async {
    final apiKey = _setting(config, ['apiKey', 'api.token', 'token']);
    if (apiKey.isEmpty) {
      return Left(ValidationFailure('Linear API key is missing'));
    }

    final core = await _linearCore(apiKey: apiKey);
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final polling = await _linearPolling(apiKey: apiKey);
    final live = await _resolveLive(config, 'linear');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testDiscord(
    ProviderConfig config,
  ) async {
    final botToken = _setting(config, ['botToken', 'api.token', 'token']);
    final guildId = _setting(config, ['guildId']);
    if (botToken.isEmpty || guildId.isEmpty) {
      return Left(
        ValidationFailure('Discord bot token and guild ID are required'),
      );
    }

    final core = await _discordCore(botToken: botToken, guildId: guildId);
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final channels = discordChannelIds(config.settings);
    final polling = await _discordPolling(botToken: botToken, channels: channels);
    final live = await _resolveLive(config, 'discord');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testPhorge(
    ProviderConfig config,
  ) async {
    final apiToken = _setting(config, ['api.token', 'apiToken', 'token']);
    final instanceUrl = phorgeInstanceUrl(
      instanceUrl: _setting(config, ['instanceUrl']),
      baseUrl: config.baseUrl,
    );
    if (apiToken.isEmpty) {
      return Left(ValidationFailure('API Token is missing'));
    }
    if (instanceUrl == null || instanceUrl.isEmpty) {
      return Left(ValidationFailure('Phorge instance URL is required'));
    }

    final core = await _phorgeCore(
      baseUrl: instanceUrl,
      apiToken: apiToken,
    );
    if (core.status == ConnectivitySectionStatus.failure) {
      return Right(
        buildReport(
          core: core,
          live: coreFailurePropagation(core.message),
          polling: coreFailurePropagation(core.message),
        ),
      );
    }

    final polling = await _phorgePolling(
      baseUrl: instanceUrl,
      apiToken: apiToken,
    );
    final live = await _resolveLive(config, 'phorge');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testFigma(
    ProviderConfig config,
  ) async {
    if (!config.isActive) {
      return Left(ValidationFailure('Provider is not active'));
    }

    final token = _setting(config, ['api.token', 'apiToken', 'token']);
    final clientId = _setting(config, ['clientId']);

    late final ProviderSectionResult core;
    if (token.isNotEmpty) {
      core = await _figmaCore(token);
      if (core.status == ConnectivitySectionStatus.failure) {
        return Right(
          buildReport(
            core: core,
            live: coreFailurePropagation(core.message),
            polling: coreFailurePropagation(core.message),
          ),
        );
      }
    } else if (clientId.isNotEmpty) {
      core = const ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message: 'OAuth client configured',
      );
    } else {
      core = const ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message: 'Configuration present',
      );
    }

    final polling = token.isNotEmpty
        ? await _figmaPolling(config, token)
        : const ProviderSectionResult(
            status: ConnectivitySectionStatus.success,
            message:
                'Explorer polls with connected Figma accounts; paste file URLs or Follow a file',
          );
    final live = await _resolveLive(config, 'figma');
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  Future<Either<Failure, ProviderConnectivityReport>> _testGeneric(
    ProviderConfig config,
  ) async {
    if (!config.isActive) {
      return Left(ValidationFailure('Provider is not active'));
    }
    if (config.baseUrl.trim().isEmpty) {
      return Left(ValidationFailure('Base URL is missing'));
    }
    const core = ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: 'Configuration present',
    );
    final live = await _resolveLive(config, config.id);
    const polling = ProviderSectionResult(
      status: ConnectivitySectionStatus.failure,
      message: 'Polling probe not implemented for this provider',
    );
    return Right(buildReport(core: core, live: live, polling: polling));
  }

  // --- Core probes ---

  Future<ProviderSectionResult> _githubCore({
    required String token,
    required String apiBaseUrl,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$apiBaseUrl/user'),
            headers: _githubHeaders(token),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final login = body['login']?.toString() ?? 'unknown';
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected as $login',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'GitHub API returned ${response.statusCode}. Verify token and API base URL.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'GitHub connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _figmaCore(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('$kFigmaApiBase/v1/me'),
            headers: figmaAuthHeaders(token),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final handle =
            (body['handle'] ?? body['email'] ?? body['id'] ?? 'unknown')
                .toString();
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected as $handle',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Figma API returned ${response.statusCode}. Verify the personal access token.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Figma connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _figmaPolling(
    ProviderConfig config,
    String token,
  ) async {
    final fileKeys = parseFigmaFileKeys(config.settings['fileKeys']);
    final teamIds = parseFigmaTeamIds(
      config.settings['teamIds'] ?? config.settings['teamId'],
    );
    if (fileKeys.isEmpty && teamIds.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message:
            'Paste file URLs so Explorer can poll comments; Connect OAuth cannot list a team',
      );
    }
    try {
      if (fileKeys.isNotEmpty) {
        final key = fileKeys.first;
        final response = await http
            .get(
              Uri.parse('$kFigmaApiBase/v1/files/$key/meta'),
              headers: figmaAuthHeaders(token),
            )
            .timeout(const Duration(seconds: 10));
        if (response.statusCode != 200) {
          return ProviderSectionResult(
            status: ConnectivitySectionStatus.failure,
            message:
                'Figma file meta returned ${response.statusCode} for $key',
          );
        }
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Reached Figma file meta for $key',
        );
      }
      final teamId = teamIds.first;
      final response = await http
          .get(
            Uri.parse('$kFigmaApiBase/v1/teams/$teamId/projects'),
            headers: figmaAuthHeaders(token),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.failure,
          message:
              'Figma team projects returned ${response.statusCode} for $teamId',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message: 'Reached Figma team $teamId',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Figma polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _slackCore({
    required String token,
    required String apiBaseUrl,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/auth.test'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json; charset=utf-8',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.failure,
          message: 'Slack API returned ${response.statusCode}.',
        );
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['ok'] != true) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.failure,
          message: 'Slack auth.test failed: ${body['error'] ?? 'unknown_error'}',
        );
      }
      final teamName = body['team']?.toString() ?? 'unknown workspace';
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message: 'Connected to Slack workspace $teamName',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Slack connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _gitlabCore({
    required String token,
    required String instanceUrl,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('$instanceUrl/api/v4/user'),
            headers: {
              'PRIVATE-TOKEN': token,
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected as ${body['username'] ?? 'unknown'}',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'GitLab API returned ${response.statusCode}. Verify API token and instance URL.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'GitLab connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _bitbucketCore({
    required String username,
    required String secret,
  }) async {
    try {
      final basic = base64Encode(utf8.encode('$username:$secret'));
      final response = await http
          .get(
            Uri.parse('https://api.bitbucket.org/2.0/user'),
            headers: {
              'Authorization': 'Basic $basic',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected as ${body['display_name'] ?? 'unknown'}',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Bitbucket API returned ${response.statusCode}. Verify username and app password.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Bitbucket connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _jiraCore({
    required String apiToken,
    required String email,
    required String instanceUrl,
  }) async {
    try {
      final credentials = base64Encode(utf8.encode('$email:$apiToken'));
      final response = await http
          .get(
            Uri.parse('$instanceUrl/rest/api/3/myself'),
            headers: {
              'Authorization': 'Basic $credentials',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected as ${body['displayName'] ?? 'unknown'}',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Jira API returned ${response.statusCode}. Verify credentials and URL.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Jira connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _linearCore({required String apiKey}) async {
    try {
      final response = await http
          .post(
            Uri.parse('https://api.linear.app/graphql'),
            headers: {
              'Authorization': apiKey,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'query': 'query { viewer { id name } }',
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['errors'] != null) {
          final errors = body['errors'] as List;
          final errorMsg = errors.isNotEmpty
              ? errors.first['message']
              : 'GraphQL error';
          return ProviderSectionResult(
            status: ConnectivitySectionStatus.failure,
            message: 'Linear GraphQL error: $errorMsg',
          );
        }
        final viewerName =
            body['data']?['viewer']?['name']?.toString() ?? 'unknown';
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected as $viewerName',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Linear API returned ${response.statusCode}. Verify API key.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Linear connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _discordCore({
    required String botToken,
    required String guildId,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('https://discord.com/api/v10/guilds/$guildId'),
            headers: {
              'Authorization': 'Bot $botToken',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Connected to server: ${body['name'] ?? 'unknown guild'}',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Discord API returned ${response.statusCode}. Verify bot token and guild ID.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Discord connectivity test failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _phorgeCore({
    required String baseUrl,
    required String apiToken,
  }) async {
    final client = HttpConduitProtocol(baseUrl: baseUrl, apiToken: apiToken);
    try {
      final result = await client
          .call('user.whoami', {})
          .timeout(const Duration(seconds: 10));
      client.dispose();
      final userName =
          result['userName'] ??
          result['realName'] ??
          result['value'] ??
          'Unknown User';
      final phid = result['phid']?.toString() ?? 'Unknown PHID';
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message: 'Connected as $userName ($phid)',
      );
    } catch (e) {
      client.dispose();
      var details = e.toString();
      if (details.contains('ERR-CONDUIT-AUTH')) {
        details = 'Invalid API Token (ERR-CONDUIT-AUTH)';
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: details,
      );
    }
  }

  // --- Polling probes ---

  Future<ProviderSectionResult> _githubPolling({
    required String token,
    required String apiBaseUrl,
    required List<String> repos,
    required String branch,
  }) async {
    if (repos.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'No repositories configured (owner/repo or repos list)',
      );
    }
    final repo = repos.first;
    try {
      final uri = Uri.parse('$apiBaseUrl/repos/$repo/commits').replace(
        queryParameters: {
          'per_page': '1',
          if (branch.isNotEmpty) 'sha': branch,
        },
      );
      final response = await http
          .get(uri, headers: _githubHeaders(token))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Commits API OK on $repo${branch.isEmpty ? '' : ' ($branch)'}',
        );
      }
      if (branch.isNotEmpty && response.statusCode >= 400) {
        final fallback = await http
            .get(
              Uri.parse('$apiBaseUrl/repos/$repo/commits')
                  .replace(queryParameters: {'per_page': '1'}),
              headers: _githubHeaders(token),
            )
            .timeout(const Duration(seconds: 10));
        if (fallback.statusCode == 200) {
          return ProviderSectionResult(
            status: ConnectivitySectionStatus.success,
            message: 'Commits API OK on $repo (default branch; configured branch unavailable)',
          );
        }
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Commits API returned ${response.statusCode} for $repo. Verify repo access and token scopes.',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'GitHub commits probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _slackPolling({
    required String token,
    required String apiBaseUrl,
    required List<String> channels,
  }) async {
    if (channels.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'No channels configured',
      );
    }
    final channelId = channels.first;
    try {
      final response = await http
          .get(
            Uri.parse('$apiBaseUrl/conversations.history').replace(
              queryParameters: {
                'channel': channelId,
                'limit': '1',
              },
            ),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['ok'] == true) {
          return ProviderSectionResult(
            status: ConnectivitySectionStatus.success,
            message: 'Channel history API OK for $channelId',
          );
        }
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.failure,
          message: 'Slack history failed: ${body['error'] ?? 'unknown_error'}',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Slack history API returned ${response.statusCode}',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Slack polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _gitlabPolling({
    required String token,
    required String apiBase,
    required List<String> projects,
    required String branch,
  }) async {
    if (projects.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'No projects configured',
      );
    }
    final project = projects.first;
    try {
      final encoded = Uri.encodeComponent(project);
      final uri = Uri.parse(
        '$apiBase/projects/$encoded/repository/commits',
      ).replace(
        queryParameters: {
          'per_page': '1',
          if (branch.isNotEmpty) 'ref_name': branch,
        },
      );
      final response = await http
          .get(
            uri,
            headers: {
              'PRIVATE-TOKEN': token,
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Commits API OK on $project',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'GitLab commits API returned ${response.statusCode} for $project',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'GitLab polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _bitbucketPolling({
    required String username,
    required String secret,
    required String workspace,
    required List<String> repos,
  }) async {
    if (workspace.isEmpty || repos.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Workspace and repos are required for polling',
      );
    }
    final repo = repos.first;
    final fullRepo = repo.contains('/') ? repo : '$workspace/$repo';
    try {
      final basic = base64Encode(utf8.encode('$username:$secret'));
      final response = await http
          .get(
            Uri.parse(
              'https://api.bitbucket.org/2.0/repositories/$fullRepo/commits',
            ).replace(queryParameters: {'pagelen': '1'}),
            headers: {
              'Authorization': 'Basic $basic',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Commits API OK on $fullRepo',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Bitbucket commits API returned ${response.statusCode} for $fullRepo',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Bitbucket polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _jiraPolling({
    required String apiToken,
    required String email,
    required String instanceUrl,
  }) async {
    try {
      final credentials = base64Encode(utf8.encode('$email:$apiToken'));
      final response = await http
          .get(
            Uri.parse('$instanceUrl/rest/api/3/search/jql').replace(
              queryParameters: {
                'jql': 'updated >= -7d ORDER BY updated DESC',
                'maxResults': '1',
                'fields': 'key',
              },
            ),
            headers: {
              'Authorization': 'Basic $credentials',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return const ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Issue search API OK',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Jira search API returned ${response.statusCode}',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Jira polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _linearPolling({required String apiKey}) async {
    try {
      final response = await http
          .post(
            Uri.parse('https://api.linear.app/graphql'),
            headers: {
              'Authorization': apiKey,
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'query': 'query { issues(first: 1) { nodes { id } } }',
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['errors'] != null) {
          return ProviderSectionResult(
            status: ConnectivitySectionStatus.failure,
            message: 'Linear issues query failed',
          );
        }
        return const ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Issues API OK',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Linear issues API returned ${response.statusCode}',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Linear polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _discordPolling({
    required String botToken,
    required List<String> channels,
  }) async {
    if (channels.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'No channels configured',
      );
    }
    final channelId = channels.first;
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://discord.com/api/v10/channels/$channelId/messages',
            ).replace(queryParameters: {'limit': '1'}),
            headers: {
              'Authorization': 'Bot $botToken',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return ProviderSectionResult(
          status: ConnectivitySectionStatus.success,
          message: 'Messages API OK for channel $channelId',
        );
      }
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Discord messages API returned ${response.statusCode}',
      );
    } catch (e) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Discord polling probe failed: $e',
      );
    }
  }

  Future<ProviderSectionResult> _phorgePolling({
    required String baseUrl,
    required String apiToken,
  }) async {
    final client = HttpConduitProtocol(baseUrl: baseUrl, apiToken: apiToken);
    try {
      await client
          .call('maniphest.search', {
            'limit': 1,
          })
          .timeout(const Duration(seconds: 10));
      client.dispose();
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.success,
        message: 'Maniphest search API OK',
      );
    } catch (e) {
      client.dispose();
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Phorge polling probe failed: $e',
      );
    }
  }

  // --- Helpers ---

  String _setting(ProviderConfig config, List<String> keys) {
    for (final key in keys) {
      final value = config.settings[key];
      if (value == null) continue;
      final trimmed = value.toString().trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }

  String _githubApiBase(Map<String, dynamic> settings) {
    final configured = (settings['apiBaseUrl'] ?? '').toString().trim();
    return (configured.isEmpty ? 'https://api.github.com' : configured)
        .replaceAll(RegExp(r'/+$'), '');
  }

  String _slackApiBase(Map<String, dynamic> settings) {
    final configured = (settings['apiBaseUrl'] ?? '').toString().trim();
    return (configured.isEmpty ? 'https://slack.com/api' : configured)
        .replaceAll(RegExp(r'/+$'), '');
  }

  Map<String, String> _githubHeaders(String token) => {
    'Accept': 'application/vnd.github+json',
    'Authorization': 'Bearer $token',
    'User-Agent': 'dab-api',
    'X-GitHub-Api-Version': '2022-11-28',
  };

  List<String> _extractSlackChannels(Map<String, dynamic> settings) {
    final channels = <String>{};
    final channelsRaw = settings['channels'];
    if (channelsRaw is List) {
      for (final entry in channelsRaw) {
        final channel = entry.toString().trim();
        if (channel.isNotEmpty) channels.add(channel);
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
    if (singleChannel.isNotEmpty) channels.add(singleChannel);
    return channels.toList();
  }
}
