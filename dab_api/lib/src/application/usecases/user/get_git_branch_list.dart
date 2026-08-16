import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/git_branch_list.dart';
import '../../../domain/contracts/ports/i_bitbucket_branch_catalog.dart';
import '../../../domain/contracts/ports/i_credential_resolver.dart';
import '../../../domain/contracts/ports/i_github_branch_catalog.dart';
import '../../../domain/contracts/ports/i_gitlab_branch_catalog.dart';
import '../../../domain/contracts/ports/i_oauth_credential_refresher.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'get_git_watch_list.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists unique branch names on the caller's selected git inbox repos.
class GetGitBranchList {
  GetGitBranchList(
    this._getWatches,
    this._resolver,
    this._github,
    this._gitlab,
    this._bitbucket,
    this._configs,
    this._oauth,
  );

  final GetGitWatchList _getWatches;
  final ICredentialResolver _resolver;
  final IGitHubBranchCatalog _github;
  final IGitLabBranchCatalog _gitlab;
  final IBitbucketBranchCatalog _bitbucket;
  final AbsIProviderConfigRepository _configs;
  final IOauthCredentialRefresher _oauth;

  Future<Either<Failure, GitBranchList>> execute({
    required String userId,
    required String providerId,
    List<String>? repos,
  }) async {
    try {
      return await _execute(
        userId: userId,
        providerId: providerId,
        repos: repos,
      );
    } catch (_) {
      return const Left(ValidationFailure('Could not list branches'));
    }
  }

  Future<Either<Failure, GitBranchList>> _execute({
    required String userId,
    required String providerId,
    List<String>? repos,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (id != 'github' && id != 'gitlab' && id != 'bitbucket') {
      return const Left(
        ValidationFailure('Git branches are for GitHub, GitLab, or Bitbucket'),
      );
    }

    final listed = await _getWatches.execute(userId: userId, providerId: id);
    if (listed.isLeft()) return Left(listed.getLeft().toNullable()!);
    final watch = listed.getOrElse((_) => throw StateError('watch list'));
    final allowedByLower = {
      for (final repo in watch.available) repo.toLowerCase(): repo,
    };
    final requested = repos ?? watch.selected;
    final scoped = <String>[];
    final seen = <String>{};
    for (final raw in requested) {
      final canonical = allowedByLower[raw.trim().toLowerCase()];
      if (canonical == null) continue;
      if (!seen.add(canonical.toLowerCase())) continue;
      scoped.add(canonical);
    }
    if (scoped.isEmpty) {
      return const Right(GitBranchList());
    }

    var userSettingsResult = await _oauth.ensureFresh(
      userId: userId,
      providerId: id,
    );
    if (userSettingsResult.isLeft()) {
      return Left(userSettingsResult.getLeft().toNullable()!);
    }
    var userSettings = userSettingsResult.getOrElse((_) => const {});
    if (userSettings.isEmpty) {
      return const Left(
        ValidationFailure('Connect this git host before choosing branches'),
      );
    }

    final orgConfigs = (await _configs.getConfigs()).getOrElse(
      (_) => const <ProviderConfig>[],
    );
    final org = orgConfigs.where((c) => c.id == id).firstOrNull;

    Future<Either<Failure, GitBranchList>> listWith(
      Map<String, dynamic> settings,
    ) {
      final merged = _resolver.overlay(
        orgSettings: org?.settings ?? const {},
        userSettings: settings,
      );
      return switch (id) {
        'github' => _github.listBranches(
          settings: merged,
          repos: scoped,
          orgConfig: org,
        ),
        'gitlab' => _gitlab.listBranches(
          settings: merged,
          repos: scoped,
          orgConfig: org,
        ),
        _ => _bitbucket.listBranches(
          settings: merged,
          repos: scoped,
          orgConfig: org,
        ),
      };
    }

    var result = await listWith(userSettings);
    if (result.isLeft() &&
        _isUnauthorized(result.getLeft().toNullable()!) &&
        isOauthCredential(userSettings)) {
      userSettingsResult = await _oauth.ensureFresh(
        userId: userId,
        providerId: id,
        force: true,
      );
      if (userSettingsResult.isRight()) {
        userSettings = userSettingsResult.getOrElse((_) => userSettings);
        result = await listWith(userSettings);
      }
    }
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      if (_isUnauthorized(failure)) {
        return const Left(
          ValidationFailure(
            'Could not list branches. Reconnect this git host in Settings.',
          ),
        );
      }
      return Left(failure);
    }
    return result;
  }
}

bool _isUnauthorized(Failure failure) {
  final message = failure.message.toLowerCase();
  return message.contains('http 401') ||
      message.contains('http 403') ||
      message.contains('unauthorized');
}
