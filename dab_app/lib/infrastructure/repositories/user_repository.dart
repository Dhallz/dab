import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import '../../domain/core/failures.dart';
import '../../domain/entities/group/group.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/entities/user/user_role.dart';
import '../../domain/entities/user/user_identity.dart';
import '../../domain/entities/user/user_identity_status.dart';
import '../../domain/entities/user/user_provider_credential_summary.dart';
import '../../domain/entities/user/activity_follow.dart';
import '../../domain/entities/user/daily_report.dart';
import '../../domain/entities/user/daily_report_line.dart';
import '../../domain/entities/user/follow_candidate.dart';
import '../../domain/entities/user/git_branch_list.dart';
import '../../domain/entities/user/git_watch_list.dart';
import '../../domain/entities/user/jira_project_watch_list.dart';
import '../../domain/entities/user/linear_team_watch_list.dart';
import '../../domain/repositories/abs_i_user_repository.dart';
import '../core/remote/rest_api_client.dart';
import './core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of User and Group directory management in the Client.
/// CONTRACT: Implements [IUserRepository].
/// CONSTRAINTS: Acts as a proxy to the REST API via [RestApiClient]. Handles DTO mapping and error guarding.
class UserRepository extends Repository implements IUserRepository {
  final RestApiClient _client;

  UserRepository(this._client);

  @override
  Future<Either<AppFailure, List<User>>> getUsers() async {
    return guardedCall(() async {
      final response = await _client.get('/users');
      final data = _getEnvelopeData(response);
      if (data is List) {
        final users = <User>[];
        for (final entry in data) {
          if (entry is! Map) continue;
          try {
            users.add(UserMapper.fromMap(Map<String, dynamic>.from(entry)));
          } catch (_) {
            continue;
          }
        }
        return users;
      }
      return [];
    });
  }

  @override
  Future<Either<AppFailure, User>> getUser(String id) async {
    return guardedCall(() async {
      final response = await _client.get('/users/$id');
      final data = _getEnvelopeData(response);
      return UserMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, List<Group>>> getGroups() async {
    return guardedCall(() async {
      final response = await _client.get('/groups');
      final data = _getEnvelopeData(response);
      if (data is List) {
        return data
            .map((e) => GroupMapper.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    });
  }

  @override
  Future<Either<AppFailure, Group>> saveGroup(Group group) async {
    print('DEBUG: UserRepository.saveGroup entry: ${group.name}');
    return guardedCall(() async {
      print('DEBUG: UserRepository.saveGroup calling POST /groups');
      final response = await _client.dio.post('/groups', data: group.toMap());
      print('DEBUG: UserRepository.saveGroup response: ${response.statusCode}');
      final data = _getEnvelopeData(response);
      return GroupMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, void>> deleteGroup(String id) async {
    return guardedCall(() async {
      await _client.dio.delete('/groups/$id');
    });
  }

  @override
  Future<Either<AppFailure, List<UserIdentity>>> getIdentities() async {
    return guardedCall(() async {
      final response = await _client.get('/admin/identities');
      final data = _getEnvelopeData(response);
      if (data is List) {
        return data
            .map((e) => UserIdentityMapper.fromMap(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    });
  }

  @override
  Future<Either<AppFailure, int>> getIdentityResolutionSummary() async {
    return guardedCall(() async {
      final response = await _client.get('/admin/identities/summary');
      final data = _getEnvelopeData(response);
      if (data is Map<String, dynamic>) {
        return (data['unresolvedCount'] as num?)?.toInt() ?? 0;
      }
      return 0;
    });
  }

  @override
  Future<Either<AppFailure, UserIdentity>> linkIdentity({
    required String userId,
    required String providerId,
    required String externalId,
    String? externalUsername,
  }) async {
    return guardedCall(() async {
      final response = await _client.dio.post(
        '/admin/identities/link',
        data: {
          'userId': userId,
          'providerId': providerId,
          'externalId': externalId,
          'externalUsername': externalUsername,
        },
      );
      final data = _getEnvelopeData(response);
      return UserIdentityMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, User>> createUser({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.standard,
  }) async {
    return guardedCall(() async {
      final response = await _client.dio.post(
        '/admin/users',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role.name,
        },
      );
      final data = _getEnvelopeData(response);
      return UserMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, void>> updateUserRole({
    required String userId,
    required UserRole role,
  }) async {
    return guardedCall(() async {
      await _client.dio.post(
        '/admin/users/role',
        data: {'userId': userId, 'role': role.name},
      );
    });
  }

  @override
  Future<Either<AppFailure, UserIdentity>> resolveIdentity({
    required String userId,
    required String providerId,
    required UserIdentityStatus status,
  }) async {
    return guardedCall(() async {
      final response = await _client.dio.post(
        '/admin/identities/resolve',
        data: {
          'userId': userId,
          'providerId': providerId,
          'status': status.name,
        },
      );
      final data = _getEnvelopeData(response);
      return UserIdentityMapper.fromMap(data as Map<String, dynamic>);
    });
  }

  @override
  Future<Either<AppFailure, void>> deleteIdentity({
    required String identityId,
  }) async {
    return guardedCall(() async {
      await _client.dio.delete('/admin/identities/$identityId');
    });
  }

  @override
  Future<Either<AppFailure, List<UserProviderCredentialSummary>>>
  listMyCredentials() {
    return guardedCall(() async {
      final response = await _client.get('/users/me/credentials');
      final data = _getEnvelopeData(response);
      if (data is List) {
        return data
            .whereType<Map>()
            .map(
              (e) => UserProviderCredentialSummary.fromMap(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      }
      return const <UserProviderCredentialSummary>[];
    });
  }

  @override
  Future<Either<AppFailure, UserProviderCredentialSummary>> saveMyCredential({
    required String providerId,
    required Map<String, dynamic> settings,
  }) {
    return guardedCall(() async {
      final response = await _client.dio.put(
        '/users/me/credentials/$providerId',
        data: {'settings': settings},
      );
      final data = _getEnvelopeData(response);
      return UserProviderCredentialSummary.fromMap(
        Map<String, dynamic>.from(data as Map),
      );
    });
  }

  @override
  Future<Either<AppFailure, void>> testMyCredential({
    required String providerId,
    Map<String, dynamic>? settings,
  }) {
    return guardedCall(() async {
      await _client.dio.post(
        '/users/me/credentials/$providerId/test',
        data: settings == null ? null : {'settings': settings},
      );
    });
  }

  @override
  Future<Either<AppFailure, void>> deleteMyCredential({
    required String providerId,
  }) {
    return guardedCall(() async {
      await _client.dio.delete('/users/me/credentials/$providerId');
    });
  }

  @override
  Future<Either<AppFailure, String>> startMyOauth({
    required String providerId,
  }) {
    return guardedCall(() async {
      final response = await _client.dio.post(
        '/users/me/credentials/$providerId/oauth/start',
      );
      final data = _getEnvelopeData(response);
      if (data is Map) {
        final url = (data['authorizationUrl'] ?? '').toString();
        if (url.isNotEmpty) return url;
      }
      throw StateError('OAuth start did not return an authorization URL');
    });
  }

  @override
  Future<Either<AppFailure, JiraProjectWatchList>> listMyJiraProjects() {
    return guardedCall(() async {
      final response = await _client.get('/users/me/credentials/jira/projects');
      final data = _getEnvelopeData(response);
      return JiraProjectWatchList.fromMap(
        Map<String, dynamic>.from(data as Map),
      );
    });
  }

  @override
  Future<Either<AppFailure, JiraProjectWatchList>> saveMyJiraProjects({
    required List<String> projectKeys,
  }) {
    return guardedCall(() async {
      final response = await _client.put(
        '/users/me/credentials/jira/projects',
        data: {'projectKeys': projectKeys},
      );
      final data = _getEnvelopeData(response);
      return JiraProjectWatchList.fromMap(
        Map<String, dynamic>.from(data as Map),
      );
    });
  }

  @override
  Future<Either<AppFailure, LinearTeamWatchList>> listMyLinearTeams() {
    return guardedCall(() async {
      final response = await _client.get(
        '/users/me/credentials/linear/projects',
      );
      final data = _getEnvelopeData(response);
      return LinearTeamWatchList.fromMap(
        Map<String, dynamic>.from(data as Map),
      );
    });
  }

  @override
  Future<Either<AppFailure, LinearTeamWatchList>> saveMyLinearTeams({
    required List<String> teamKeys,
  }) {
    return guardedCall(() async {
      final response = await _client.put(
        '/users/me/credentials/linear/projects',
        data: {'teamKeys': teamKeys},
      );
      final data = _getEnvelopeData(response);
      return LinearTeamWatchList.fromMap(
        Map<String, dynamic>.from(data as Map),
      );
    });
  }

  @override
  Future<Either<AppFailure, GitWatchList>> listMyGitWatches({
    required String providerId,
  }) {
    return guardedCall(() async {
      final response = await _client.get(
        '/users/me/credentials/$providerId/projects',
      );
      final data = _getEnvelopeData(response);
      return GitWatchList.fromMap(Map<String, dynamic>.from(data as Map));
    });
  }

  @override
  Future<Either<AppFailure, GitWatchList>> saveMyGitWatches({
    required String providerId,
    required List<String> repos,
    List<String> branches = const [],
  }) {
    return guardedCall(() async {
      final response = await _client.put(
        '/users/me/credentials/$providerId/projects',
        data: {'repos': repos, 'branches': branches},
      );
      final data = _getEnvelopeData(response);
      return GitWatchList.fromMap(Map<String, dynamic>.from(data as Map));
    });
  }

  @override
  Future<Either<AppFailure, GitBranchList>> listMyGitBranches({
    required String providerId,
    List<String> repos = const [],
  }) {
    return guardedCall(() async {
      final response = await _client.get(
        '/users/me/credentials/$providerId/branches',
        queryParameters: {'repos': repos.join(',')},
      );
      final data = _getEnvelopeData(response);
      return GitBranchList.fromMap(Map<String, dynamic>.from(data as Map));
    });
  }

  @override
  Future<Either<AppFailure, List<FollowCandidate>>> listMyFollowCandidates({
    String query = '',
  }) {
    return guardedCall(() async {
      final response = await _client.get(
        '/users/me/follows/candidates',
        queryParameters: {if (query.trim().isNotEmpty) 'q': query.trim()},
      );
      final data = _getEnvelopeData(response);
      if (data is! List) return const <FollowCandidate>[];
      final rows = <FollowCandidate>[];
      for (final item in data) {
        if (item is! Map) continue;
        rows.add(FollowCandidate.fromMap(Map<String, dynamic>.from(item)));
      }
      return rows;
    });
  }

  @override
  Future<Either<AppFailure, List<ActivityFollow>>> listMyActivityFollows() {
    return guardedCall(() async {
      final response = await _client.get('/users/me/follows');
      final data = _getEnvelopeData(response);
      if (data is! List) return const <ActivityFollow>[];
      final follows = <ActivityFollow>[];
      for (final item in data) {
        if (item is! Map) continue;
        follows.add(ActivityFollow.fromMap(Map<String, dynamic>.from(item)));
      }
      return follows;
    });
  }

  @override
  Future<Either<AppFailure, ActivityFollow>> saveMyActivityFollow({
    required String providerId,
    required String objectKey,
    String? title,
    String? url,
  }) {
    return guardedCall(() async {
      final response = await _client.put(
        '/users/me/follows',
        data: {
          'providerId': providerId,
          'objectKey': objectKey,
          if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
          if (url != null && url.trim().isNotEmpty) 'url': url.trim(),
        },
      );
      final data = _getEnvelopeData(response);
      return ActivityFollow.fromMap(Map<String, dynamic>.from(data as Map));
    });
  }

  @override
  Future<Either<AppFailure, void>> deleteMyActivityFollow({
    required String providerId,
    required String objectKey,
  }) {
    return guardedCall(() async {
      await _client.dio.delete(
        '/users/me/follows',
        data: {'providerId': providerId, 'objectKey': objectKey},
      );
    });
  }

  @override
  Future<Either<AppFailure, DailyReport>> getMyDailyReport({
    required String date,
  }) {
    return guardedCall(() async {
      final response = await _client.get('/users/me/day-reports/$date');
      final data = _getEnvelopeData(response);
      return DailyReport.fromApiMap(Map<String, dynamic>.from(data as Map));
    });
  }

  @override
  Future<Either<AppFailure, DailyReport>> getUserDailyReport({
    required String userId,
    required String date,
  }) {
    return guardedCall(() async {
      final response = await _client.get('/users/$userId/day-reports/$date');
      final data = _getEnvelopeData(response);
      return DailyReport.fromApiMap(Map<String, dynamic>.from(data as Map));
    });
  }

  @override
  Future<Either<AppFailure, List<String>>> listMyDailyReports() {
    return guardedCall(() async {
      final response = await _client.get('/users/me/day-reports');
      return _dateList(_getEnvelopeData(response));
    });
  }

  @override
  Future<Either<AppFailure, List<String>>> listUserDailyReports({
    required String userId,
  }) {
    return guardedCall(() async {
      final response = await _client.get('/users/$userId/day-reports');
      return _dateList(_getEnvelopeData(response));
    });
  }

  @override
  Future<Either<AppFailure, DailyReport>> saveMyDailyReport({
    required String date,
    required bool includeFollowing,
    required List<DailyReportLine> lines,
  }) {
    return guardedCall(() async {
      final response = await _client.put(
        '/users/me/day-reports/$date',
        data: {
          'includeFollowing': includeFollowing,
          'lines': lines.map((line) => line.toApiMap()).toList(),
        },
      );
      final data = _getEnvelopeData(response);
      return DailyReport.fromApiMap(Map<String, dynamic>.from(data as Map));
    });
  }

  dynamic _getEnvelopeData(Response response) {
    if (response.statusCode == 304 || response.data == null) return null;

    final dynamic data = response.data;
    final Map<String, dynamic> map;

    if (data is Map<String, dynamic>) {
      map = data;
    } else {
      map = jsonDecode(data.toString());
    }

    return map['data'];
  }

  List<String> _dateList(dynamic data) {
    if (data is! List) return const [];
    return [
      for (final item in data)
        if (item is String && item.trim().isNotEmpty) item.trim(),
    ];
  }
}
