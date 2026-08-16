import 'package:dab_api/src/application/usecases/user/get_git_branch_list.dart';
import 'package:dab_api/src/application/usecases/user/get_git_watch_list.dart';
import 'package:dab_api/src/domain/contracts/ports/i_bitbucket_branch_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_github_branch_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_gitlab_branch_catalog.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/git_branch_list.dart';
import 'package:dab_api/src/domain/entities/user/git_watch_list.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';
import '../../../fakes/fake_oauth_credential_refresher.dart';

class _MockWatches extends Mock implements GetGitWatchList {}

class _MockGitHub extends Mock implements IGitHubBranchCatalog {}

class _MockGitLab extends Mock implements IGitLabBranchCatalog {}

class _MockBitbucket extends Mock implements IBitbucketBranchCatalog {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late _MockWatches watches;
  late FakeCredentialResolver resolver;
  late _MockGitHub github;
  late _MockGitLab gitlab;
  late _MockBitbucket bitbucket;
  late _MockConfigs configs;
  late FakeOauthCredentialRefresher oauth;
  late GetGitBranchList useCase;

  final githubConfig = ProviderConfig(
    id: 'github',
    name: 'GitHub',
    baseUrl: 'https://github.com',
    isActive: true,
    settings: const {'owner': 'Acme', 'repo': 'app'},
  );

  const userSettings = {'api.token': 'tok'};

  setUpAll(() {
    registerFallbackValue(githubConfig);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    watches = _MockWatches();
    resolver = FakeCredentialResolver({'u-1': userSettings});
    github = _MockGitHub();
    gitlab = _MockGitLab();
    bitbucket = _MockBitbucket();
    configs = _MockConfigs();
    oauth = FakeOauthCredentialRefresher({'u-1': userSettings});
    useCase = GetGitBranchList(
      watches,
      resolver,
      github,
      gitlab,
      bitbucket,
      configs,
      oauth,
    );
    when(
      () => configs.getConfigs(),
    ).thenAnswer((_) async => Right([githubConfig]));
    when(() => watches.execute(userId: 'u-1', providerId: 'github')).thenAnswer(
      (_) async => const Right(
        GitWatchList(available: ['Acme/app'], selected: ['Acme/app']),
      ),
    );
  });

  test('returns empty when no selected repos are requested', () async {
    final out = await useCase.execute(
      userId: 'u-1',
      providerId: 'github',
      repos: const [],
    );
    expect(out.getOrElse((_) => throw StateError('left')).available, isEmpty);
    verifyNever(
      () => github.listBranches(
        settings: any(named: 'settings'),
        repos: any(named: 'repos'),
        orgConfig: any(named: 'orgConfig'),
      ),
    );
  });

  test('lists GitHub branches for scoped selected repos', () async {
    when(
      () => github.listBranches(
        settings: any(named: 'settings'),
        repos: ['Acme/app'],
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer(
      (_) async => const Right(GitBranchList(available: ['main', 'develop'])),
    );

    final out = await useCase.execute(userId: 'u-1', providerId: 'github');
    final list = out.getOrElse((_) => throw StateError('left'));
    expect(list.available, ['main', 'develop']);
    verifyNever(
      () => gitlab.listBranches(
        settings: any(named: 'settings'),
        repos: any(named: 'repos'),
        orgConfig: any(named: 'orgConfig'),
      ),
    );
  });

  test('maps unexpected throws to a validation failure', () async {
    when(
      () => watches.execute(userId: 'u-1', providerId: 'github'),
    ).thenThrow(StateError('boom'));

    final out = await useCase.execute(userId: 'u-1', providerId: 'github');
    expect(out.isLeft(), isTrue);
    expect(out.getLeft().toNullable()?.message, 'Could not list branches');
  });
}
