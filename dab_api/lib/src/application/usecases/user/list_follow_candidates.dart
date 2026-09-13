import 'package:fpdart/fpdart.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/follow_candidate_query.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/contracts/ports/abs_i_follow_candidate_catalog.dart';
import 'get_git_branch_list.dart';
import 'get_git_watch_list.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists Follow picker rows: issues whose **title contains** [query]
/// plus git branches. Empty [query] is involved issues only.
class ListFollowCandidates {
  ListFollowCandidates(
    this._issueCatalogs,
    this._gitWatches,
    this._gitBranches,
  );

  final List<AbsIFollowCandidateCatalog> _issueCatalogs;
  final GetGitWatchList _gitWatches;
  final GetGitBranchList _gitBranches;

  static const _cap = 40;

  Future<Either<Failure, List<FollowCandidate>>> execute({
    required String userId,
    String query = '',
  }) async {
    try {
      final q = query.trim();
      final chunks = await Future.wait([
        ..._issueCatalogs.map(
          (catalog) => catalog.list(userId: userId, query: q),
        ),
        _gitCandidates(userId: userId, query: q, providerId: 'github'),
        _gitCandidates(userId: userId, query: q, providerId: 'gitlab'),
        _gitCandidates(userId: userId, query: q, providerId: 'bitbucket'),
      ]);
      final buckets = [
        for (final chunk in chunks)
          [
            for (final row in chunk.getOrElse((_) => const <FollowCandidate>[]))
              if (followCandidateTitleContains(row, q)) row,
          ],
      ];
      return Right(_interleave(buckets));
    } catch (_) {
      return const Right([]);
    }
  }

  /// Round-robins provider catalogs so one source cannot fill [_cap] alone.
  List<FollowCandidate> _interleave(List<List<FollowCandidate>> buckets) {
    final seen = <String>{};
    final out = <FollowCandidate>[];
    var index = 0;
    var progressed = true;
    while (progressed && out.length < _cap) {
      progressed = false;
      for (final bucket in buckets) {
        if (index >= bucket.length) continue;
        progressed = true;
        final row = bucket[index];
        final ref = followObjectRef(row.providerId, row.objectKey);
        if (!seen.add(ref)) continue;
        out.add(row);
        if (out.length >= _cap) return out;
      }
      index++;
    }
    return out;
  }

  Future<Either<Failure, List<FollowCandidate>>> _gitCandidates({
    required String userId,
    required String query,
    required String providerId,
  }) async {
    if (query.isEmpty) return const Right([]);
    final listed = await _gitWatches.execute(
      userId: userId,
      providerId: providerId,
    );
    if (listed.isLeft()) return const Right([]);
    final watch = listed.getOrElse((_) => throw StateError('watch'));
    final needle = query.toLowerCase();
    final out = <FollowCandidate>[];
    var repos = 0;
    for (final repo in watch.available) {
      if (repos >= 6) break;
      repos++;
      final branches = await _gitBranches.execute(
        userId: userId,
        providerId: providerId,
        repos: [repo],
      );
      if (branches.isLeft()) continue;
      final names = branches.getOrElse((_) => throw StateError('branches'));
      for (final name in names.available) {
        if (!repo.toLowerCase().contains(needle) &&
            !name.toLowerCase().contains(needle)) {
          continue;
        }
        final key = gitFollowObjectKey(repo, name);
        if (key == null) continue;
        out.add(
          FollowCandidate(
            providerId: providerId,
            objectKey: key,
            title: '$repo · $name',
            url: _browseUrl(providerId, repo, name),
            kind: 'gitBranch',
          ),
        );
        if (out.length >= 12) return Right(out);
      }
    }
    return Right(out);
  }

  String? _browseUrl(String providerId, String repo, String branch) {
    final encoded = Uri.encodeComponent(branch);
    return switch (providerId) {
      'github' => 'https://github.com/$repo/tree/$encoded',
      'gitlab' => 'https://gitlab.com/$repo/-/tree/$encoded',
      'bitbucket' => 'https://bitbucket.org/$repo/branch/$encoded',
      _ => null,
    };
  }
}
