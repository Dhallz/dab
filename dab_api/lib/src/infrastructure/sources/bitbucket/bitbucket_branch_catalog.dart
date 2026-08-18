import 'package:fpdart/fpdart.dart';

import '../../../domain/core/bitbucket_scope.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/git_branch_names.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/git_branch_list.dart';
import '../../../domain/contracts/ports/abs_i_bitbucket_branch_catalog.dart';
import '../../protocols/protocol_exceptions.dart';
import '../../protocols/rest/json_rest_protocol.dart';
import 'bitbucket_commit_source.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists Bitbucket branch names for Settings inbox watches. Read-only.
class BitbucketBranchCatalog implements AbsIBitbucketBranchCatalog {
  BitbucketBranchCatalog(this._jsonRest);

  final JsonRestProtocol _jsonRest;

  static const _pageSize = 100;
  static const _maxPagesPerRepo = 3;

  @override
  Future<Either<Failure, GitBranchList>> listBranches({
    required Map<String, dynamic> settings,
    required List<String> repos,
    ProviderConfig? orgConfig,
  }) async {
    final headers = bitbucketAuthHeaders(settings);
    if (headers == null) {
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
          headers: headers,
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
      return const Left(ValidationFailure('Could not list Bitbucket branches'));
    }
  }

  Future<({List<String> names, bool truncated})> _branchesForRepo({
    required Map<String, dynamic> settings,
    required Map<String, String> headers,
    required String repo,
    required int remaining,
  }) async {
    final parts = _repoParts(settings, repo);
    if (parts == null) return (names: const <String>[], truncated: false);
    final names = <String>[];
    var truncated = false;
    var next = Uri.parse(
      'https://api.bitbucket.org/2.0/repositories/${parts.$1}/${parts.$2}/refs/branches',
    ).replace(queryParameters: {'pagelen': '$_pageSize'});
    for (var page = 1; page <= _maxPagesPerRepo; page++) {
      if (names.length >= remaining) {
        truncated = true;
        break;
      }
      final body = await _getJsonMapOrEmpty(next, headers);
      if (body.isEmpty) {
        return (names: names, truncated: truncated);
      }
      final values = body['values'];
      if (values is List) {
        for (final row in values) {
          if (row is! Map) continue;
          final name = (row['name'] ?? '').toString().trim();
          if (name.isEmpty) continue;
          names.add(name);
          if (names.length >= remaining) {
            return (names: names, truncated: true);
          }
        }
      }
      final nextRaw = (body['next'] ?? '').toString().trim();
      if (nextRaw.isEmpty) {
        return (names: names, truncated: truncated);
      }
      if (page == _maxPagesPerRepo) {
        truncated = true;
        break;
      }
      next = Uri.parse(nextRaw);
    }
    return (names: names, truncated: truncated);
  }

  (String, String)? _repoParts(Map<String, dynamic> settings, String repo) {
    final trimmed = repo.trim();
    if (trimmed.contains('/')) {
      final slash = trimmed.indexOf('/');
      final workspace = trimmed.substring(0, slash).trim();
      final slug = trimmed.substring(slash + 1).trim();
      if (workspace.isEmpty || slug.isEmpty) return null;
      return (workspace, slug);
    }
    final workspace = bitbucketWorkspace(settings);
    if (workspace.isEmpty || trimmed.isEmpty) return null;
    return (workspace, trimmed);
  }

  Future<Map<String, dynamic>> _getJsonMapOrEmpty(
    Uri uri,
    Map<String, String> headers,
  ) async {
    try {
      return await _jsonRest.getJsonMap(uri, headers: headers);
    } on JsonRestProtocolException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) rethrow;
      return const {};
    }
  }
}
