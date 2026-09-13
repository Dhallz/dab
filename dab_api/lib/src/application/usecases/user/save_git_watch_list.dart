import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/git_watch_list.dart';
import '../../../domain/entities/user/user_provider_credential.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';
import 'get_git_watch_list.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves per-user git inbox watches onto the caller's credential settings.
class SaveGitWatchList {
  SaveGitWatchList(this._get, this._credentials);

  final GetGitWatchList _get;
  final AbsIUserProviderCredentialRepository _credentials;

  Future<Either<Failure, GitWatchList>> execute({
    required String userId,
    required String providerId,
    required List<String> repos,
    List<String> branches = const [],
  }) async {
    final listed = await _get.execute(userId: userId, providerId: providerId);
    if (listed.isLeft()) return Left(listed.getLeft().toNullable()!);
    final watch = listed.getOrElse((_) => throw StateError('watch list'));
    final allowed = {...watch.available, ...repos.map((r) => r.trim())};
    final selected = [
      for (final repo in repos)
        if (repo.trim().isNotEmpty && allowed.contains(repo.trim()))
          repo.trim(),
    ];
    final cleanBranches = [
      for (final branch in branches)
        if (branch.trim().isNotEmpty) branch.trim(),
    ];

    final existing = await _credentials.get(
      userId: userId,
      providerId: providerId.trim().toLowerCase(),
    );
    if (existing.isLeft()) return Left(existing.getLeft().toNullable()!);
    final row = existing.getOrElse((_) => null);
    if (row == null) {
      return const Left(
        ValidationFailure('Connect this git host before choosing watches'),
      );
    }
    final next = Map<String, dynamic>.from(row.settings);
    next['watchedRepos'] = selected;
    next['watchedBranches'] = cleanBranches;
    final saved = await _credentials.save(
      UserProviderCredential(
        id: row.id,
        userId: row.userId,
        providerId: row.providerId,
        settings: next,
        status: row.status,
        createdAt: row.createdAt,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    if (saved.isLeft()) return Left(saved.getLeft().toNullable()!);
    return Right(
      GitWatchList(
        available: watch.available,
        selected: selected,
        branches: cleanBranches,
      ),
    );
  }
}
