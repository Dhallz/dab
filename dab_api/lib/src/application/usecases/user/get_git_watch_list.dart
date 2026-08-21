import 'package:fpdart/fpdart.dart';

import '../../../domain/core/bitbucket_scope.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/git_watch_scope.dart';
import '../../../domain/core/github_scope.dart';
import '../../../domain/core/gitlab_scope.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/git_watch_list.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists instance git repos plus the caller's personal inbox watches.
class GetGitWatchList {
  GetGitWatchList(this._resolver, this._configs);

  final AbsICredentialResolver _resolver;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, GitWatchList>> execute({
    required String userId,
    required String providerId,
  }) async {
    try {
      return await _execute(
        userId: userId,
        providerId: providerId,
      );
    } catch (_) {
      return const Left(ValidationFailure('Could not load git inbox watches'));
    }
  }

  Future<Either<Failure, GitWatchList>> _execute({
    required String userId,
    required String providerId,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (id != 'github' && id != 'gitlab' && id != 'bitbucket') {
      return const Left(ValidationFailure('Git watches are for GitHub, GitLab, or Bitbucket'));
    }
    final configs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = configs.where((c) => c.id == id).firstOrNull;
    final instance = _instanceRepos(id, org?.settings ?? const {});
    final userSettings = await _resolver.getUserSettings(
      userId: userId,
      providerId: id,
    );
    if (userSettings == null) {
      return const Left(ValidationFailure('Connect this git host before choosing watches'));
    }
    final selected = userSettings.effectiveWatchedRepos(instance);
    final branches = userSettings.parseWatchedBranches();
    final available = {
      for (final repo in [...instance, ...selected])
        if (repo.trim().isNotEmpty) repo.trim(),
    }.toList()..sort();
    return Right(
      GitWatchList(
        available: available,
        selected: selected,
        branches: branches,
      ),
    );
  }

  List<String> _instanceRepos(String id, Map<String, dynamic> settings) {
    return switch (id) {
      'github' => settings.extractConfiguredGithubRepos(),
      'gitlab' => settings.gitLabProjects(),
      'bitbucket' => settings.bitbucketRepos(),
      _ => const [],
    };
  }
}
