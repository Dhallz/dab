import 'package:fpdart/fpdart.dart';

import '../../../domain/core/bitbucket_scope.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/git_watch_scope.dart';
import '../../../domain/core/github_scope.dart';
import '../../../domain/core/gitlab_scope.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/git_watch_list.dart';
import '../../../domain/contracts/ports/i_credential_resolver.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists instance git repos plus the caller's personal inbox watches.
class GetGitWatchList {
  GetGitWatchList(this._resolver, this._configs);

  final ICredentialResolver _resolver;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, GitWatchList>> execute({
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
    final selected = effectiveWatchedRepos(
      settings: userSettings,
      instanceRepos: instance,
    );
    final branches = parseWatchedBranches(userSettings);
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
      'github' => extractConfiguredGithubRepos(settings),
      'gitlab' => gitLabProjects(settings),
      'bitbucket' => bitbucketRepos(settings),
      _ => const [],
    };
  }
}
