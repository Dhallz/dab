import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:relic/relic.dart';

import '../../application/containers/user_usecases.dart';
import '../../application/services/identity_discovery_service.dart';
import '../../domain/core/failures/failure.dart';
import '../../infrastructure/sources/discord/discord_gateway_client.dart';
import '../../service_locator.dart';
import '../middlewares/auth_middleware.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for User Directory and Synchronization.
/// CONTRACT: Maps HTTP requests for user retrieval and Phorge syncing to [UserUseCases].
/// CONSTRAINTS: Acts as a thin wrapper for UseCase execution and JSON serialization.
class UserController {
  final UserUseCases _user = sl<UserUseCases>();

  Future<Response> getUsers(Request request) async {
    final result = await _user.getUsers.execute();
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (users) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': users.map((u) => u.toMap()).toList(),
            'meta': {
              'dataType': 'list:user',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> getUser(Request request) async {
    final id = request.pathParameters.raw[#id];
    if (id == null) return Response.badRequest();

    final result = await _user.getUserById.execute(id);
    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return Response.notFound(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (user) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': user.toMap(),
            'meta': {
              'dataType': 'user',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> syncUsers(Request request) async {
    final result = await _user.syncPhorgeUsers.execute();
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      if (failure is NotFoundFailure) {
        return Response.notFound(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      }
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      );
    }
    final count = result.getRight().toNullable()!;
    unawaited(sl<IdentityDiscoveryService>().runFullDiscovery());

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'createdCount': count},
          'meta': {
            'dataType': 'sync_result',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  Future<Response> startMyOauth(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '').toString();
    final result = await _user.startProviderOauth.execute(
      userId: userId,
      providerId: provider,
    );
    return result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          return Response.badRequest(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (authorizationUrl) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': {'authorizationUrl': authorizationUrl},
            'meta': {
              'dataType': 'oauth_start',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> listMyCredentials(Request request) async {
    final userId = userIdProperty.get(request);
    final result = await _user.listUserProviderCredentials.execute(userId);
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (list) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': list.map((s) => s.toMap()).toList(),
            'meta': {
              'dataType': 'list:user_provider_credential',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> getMyJiraProjects(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    if (provider == 'jira') {
      return _watchListResponse(
        await _user.getJiraProjectWatchList.execute(userId),
        'jira_project_watch_list',
      );
    }
    if (provider == 'linear') {
      return _watchListResponse(
        await _user.getLinearTeamWatchList.execute(userId),
        'linear_team_watch_list',
      );
    }
    if (provider == 'github' ||
        provider == 'gitlab' ||
        provider == 'bitbucket') {
      return _watchListResponse(
        await _user.getGitWatchList.execute(
          userId: userId,
          providerId: provider,
        ),
        'git_watch_list',
      );
    }
    return Response.badRequest(
      body: Body.fromString(
        jsonEncode({
          'error':
              'Watch list picker is only available for Jira, Linear, GitHub, GitLab, and Bitbucket',
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  Future<Response> getMyGitBranches(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    if (provider != 'github' &&
        provider != 'gitlab' &&
        provider != 'bitbucket') {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error':
                'Branch picker is only available for GitHub, GitLab, and Bitbucket',
          }),
          mimeType: MimeType.json,
        ),
      );
    }
    final reposParam = request.url.queryParameters['repos'];
    List<String>? repos;
    if (reposParam != null) {
      repos = [
        for (final part in reposParam.split(','))
          if (part.trim().isNotEmpty) part.trim(),
      ];
    }
    return _watchListResponse(
      await _user.getGitBranchList.execute(
        userId: userId,
        providerId: provider,
        repos: repos,
      ),
      'git_branch_list',
    );
  }

  Future<Response> saveMyJiraProjects(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '')
        .toString()
        .trim()
        .toLowerCase();
    if (provider != 'jira' &&
        provider != 'linear' &&
        provider != 'github' &&
        provider != 'gitlab' &&
        provider != 'bitbucket') {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error':
                'Watch list picker is only available for Jira, Linear, GitHub, GitLab, and Bitbucket',
          }),
          mimeType: MimeType.json,
        ),
      );
    }
    try {
      final bodyStr = await request.readAsString();
      final data = bodyStr.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(bodyStr);
      final rawKeys = data is Map
          ? (data['teamKeys'] ??
                data['projectKeys'] ??
                data['repos'] ??
                data['selected'])
          : null;
      final keys = <String>[];
      if (rawKeys is List) {
        for (final item in rawKeys) {
          keys.add(item.toString());
        }
      }
      final rawBranches = data is Map ? data['branches'] : null;
      final branches = <String>[];
      if (rawBranches is List) {
        for (final item in rawBranches) {
          branches.add(item.toString());
        }
      }
      if (provider == 'linear') {
        return _watchListResponse(
          await _user.saveLinearTeamWatchList.execute(
            userId: userId,
            teamKeys: keys,
          ),
          'linear_team_watch_list',
        );
      }
      if (provider == 'jira') {
        return _watchListResponse(
          await _user.saveJiraProjectWatchList.execute(
            userId: userId,
            projectKeys: keys,
          ),
          'jira_project_watch_list',
        );
      }
      return _watchListResponse(
        await _user.saveGitWatchList.execute(
          userId: userId,
          providerId: provider,
          repos: keys,
          branches: branches,
        ),
        'git_watch_list',
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid request body',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Response _watchListResponse(
    Either<Failure, dynamic> result,
    String dataType,
  ) {
    return result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          return Response.badRequest(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (watchList) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': watchList.toMap(),
            'meta': {
              'dataType': dataType,
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> saveMyCredential(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '').toString();
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr);
      final settings = data is Map<String, dynamic>
          ? Map<String, dynamic>.from(
              data['settings'] is Map ? data['settings'] as Map : data,
            )
          : <String, dynamic>{};
      final result = await _user.saveUserProviderCredential.execute(
        userId: userId,
        providerId: provider,
        settings: settings,
      );
      return result.fold(
        (failure) {
          if (failure is ValidationFailure) {
            return Response.badRequest(
              body: Body.fromString(
                jsonEncode({'error': failure.message}),
                mimeType: MimeType.json,
              ),
            );
          }
          return Response.internalServerError(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        },
        (summary) {
          if (provider.trim().toLowerCase() == 'discord') {
            sl<DiscordGatewayClient>().reload().catchError((e) {
              print('Error reloading DiscordGatewayClient: $e');
            });
          }
          return Response.ok(
            body: Body.fromString(
              jsonEncode({
                'data': summary.toMap(),
                'meta': {
                  'dataType': 'user_provider_credential',
                  'timestamp': DateTime.now().toIso8601String(),
                },
              }),
              mimeType: MimeType.json,
            ),
          );
        },
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid request body',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> testMyCredential(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '').toString();
    Map<String, dynamic>? settings;
    try {
      final bodyStr = await request.readAsString();
      if (bodyStr.trim().isNotEmpty) {
        final data = jsonDecode(bodyStr);
        if (data is Map<String, dynamic>) {
          settings = Map<String, dynamic>.from(
            data['settings'] is Map ? data['settings'] as Map : data,
          );
        }
      }
    } catch (_) {}
    final result = await _user.testUserProviderCredential.execute(
      userId: userId,
      providerId: provider,
      settings: settings,
    );
    return result.fold(
      (failure) => Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (_) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': {'ok': true},
            'meta': {
              'dataType': 'credential_test',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> deleteMyCredential(Request request) async {
    final userId = userIdProperty.get(request);
    final provider = (request.pathParameters.raw[#provider] ?? '').toString();
    final result = await _user.deleteUserProviderCredential.execute(
      userId: userId,
      providerId: provider,
    );
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (_) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': {'deleted': true},
            'meta': {
              'dataType': 'credential_delete',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> listMyFollowCandidates(Request request) async {
    final userId = userIdProperty.get(request);
    final query = (request.url.queryParameters['q'] ?? '').trim();
    final result = await _user.listFollowCandidates.execute(
      userId: userId,
      query: query,
    );
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (list) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': list.map((row) => row.toApiMap()).toList(),
            'meta': {
              'dataType': 'list:follow_candidate',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> listMyFollows(Request request) async {
    final userId = userIdProperty.get(request);
    final result = await _user.listMyActivityFollows.execute(userId: userId);
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (list) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': list.map((follow) => follow.toApiMap()).toList(),
            'meta': {
              'dataType': 'list:activity_follow',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> saveMyFollow(Request request) async {
    final userId = userIdProperty.get(request);
    final body = await _readFollowBody(request);
    if (body == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Body must include providerId and objectKey'}),
          mimeType: MimeType.json,
        ),
      );
    }
    final result = await _user.saveActivityFollow.execute(
      userId: userId,
      providerId: body.providerId,
      objectKey: body.objectKey,
      title: body.title,
      url: body.url,
    );
    return result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          return Response.badRequest(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (follow) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': follow.toApiMap(),
            'meta': {
              'dataType': 'activity_follow',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> deleteMyFollow(Request request) async {
    final userId = userIdProperty.get(request);
    final body = await _readFollowBody(request);
    if (body == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Body must include providerId and objectKey'}),
          mimeType: MimeType.json,
        ),
      );
    }
    final result = await _user.deleteActivityFollow.execute(
      userId: userId,
      providerId: body.providerId,
      objectKey: body.objectKey,
    );
    return result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          return Response.badRequest(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (_) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': {'deleted': true},
            'meta': {
              'dataType': 'activity_follow_delete',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<({String providerId, String objectKey, String? title, String? url})?>
  _readFollowBody(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = bodyStr.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(bodyStr);
      if (data is! Map) return null;
      final providerId = (data['providerId'] ?? '').toString().trim();
      final objectKey = (data['objectKey'] ?? '').toString().trim();
      if (providerId.isEmpty || objectKey.isEmpty) return null;
      final title = (data['title'] ?? '').toString().trim();
      final url = (data['url'] ?? '').toString().trim();
      return (
        providerId: providerId,
        objectKey: objectKey,
        title: title.isEmpty ? null : title,
        url: url.isEmpty ? null : url,
      );
    } catch (_) {
      return null;
    }
  }
}
