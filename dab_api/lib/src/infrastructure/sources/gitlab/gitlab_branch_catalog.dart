import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/git_branch_names.dart';
import '../../../domain/core/gitlab_scope.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/git_branch_list.dart';
import '../../../domain/contracts/ports/abs_i_gitlab_branch_catalog.dart';
import '../../protocols/protocol_exceptions.dart';
import '../../protocols/rest/json_rest_protocol.dart';
import 'gitlab_commit_source.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists GitLab branch names for Settings inbox watches. Read-only.
class GitLabBranchCatalog implements AbsIGitLabBranchCatalog {
  GitLabBranchCatalog(this._jsonRest);

  final JsonRestProtocol _jsonRest;

  static const _pageSize = 100;
  static const _maxPagesPerRepo = 3;

  @override
  Future<Either<Failure, GitBranchList>> listBranches({
    required Map<String, dynamic> settings,
    required List<String> repos,
    ProviderConfig? orgConfig,
  }) async {
    final token = extractProviderToken('gitlab', settings);
    if (token.isEmpty) {
      return const Left(ValidationFailure('HTTP 401'));
    }
    try {
      final names = <String>{};
      var truncated = false;
      for (final repo in repos) {
        if (names.length >= kGitBranchNameCap) {
          truncated = true;
          break;
        }
        final listed = await _branchesForRepo(
          settings: settings,
          orgConfig: orgConfig,
          repo: repo,
          remaining: kGitBranchNameCap - names.length,
        );
        truncated = truncated || listed.truncated;
        names.addAll(listed.names);
      }
      return Right(gitBranchListFromNames(names, truncated: truncated));
    } on JsonRestProtocolException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        return const Left(ValidationFailure('HTTP 401'));
      }
      return Left(ValidationFailure(e.message));
    } catch (_) {
      return const Left(ValidationFailure('Could not list GitLab branches'));
    }
  }

  Future<({List<String> names, bool truncated})> _branchesForRepo({
    required Map<String, dynamic> settings,
    required ProviderConfig? orgConfig,
    required String repo,
    required int remaining,
  }) async {
    final apiBase = gitLabApiBase(settings, orgConfig?.baseUrl ?? '');
    final headers = gitLabAuthHeaders(settings);
    final encoded = Uri.encodeComponent(repo);
    final names = <String>[];
    var truncated = false;
    for (var page = 1; page <= _maxPagesPerRepo; page++) {
      if (names.length >= remaining) {
        truncated = true;
        break;
      }
      final uri = Uri.parse(
        '$apiBase/projects/$encoded/repository/branches',
      ).replace(queryParameters: {'per_page': '$_pageSize', 'page': '$page'});
      final rows = await _getJsonListOrEmpty(uri, headers);
      for (final row in rows) {
        if (row is! Map) continue;
        final name = (row['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        names.add(name);
        if (names.length >= remaining) {
          return (names: names, truncated: true);
        }
      }
      if (rows.length < _pageSize) {
        return (names: names, truncated: truncated);
      }
      if (page == _maxPagesPerRepo) truncated = true;
    }
    return (names: names, truncated: truncated);
  }

  Future<List<dynamic>> _getJsonListOrEmpty(
    Uri uri,
    Map<String, String> headers,
  ) async {
    try {
      return await _jsonRest.getJsonList(uri, headers: headers);
    } on JsonRestProtocolException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) rethrow;
      return const [];
    }
  }
}
