import 'package:dab_api/src/application/usecases/user/get_jira_project_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/save_jira_project_watch_list.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/jira_project.dart';
import 'package:dab_api/src/domain/contracts/ports/i_jira_project_catalog.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../fakes/fake_credential_resolver.dart';
import '../../../fakes/fake_oauth_credential_refresher.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCatalog extends Mock implements IJiraProjectCatalog {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late FakeCredentialResolver resolver;
  late FakeOauthCredentialRefresher oauth;
  late _MockCatalog catalog;
  late _MockConfigs configs;
  late GetJiraProjectWatchList getWatch;
  late SaveJiraProjectWatchList saveWatch;

  final jiraConfig = ProviderConfig(
    id: 'jira',
    name: 'Jira',
    baseUrl: 'https://acme.atlassian.net',
    isActive: true,
    settings: const {'projectKeys': 'DAB\nOPS'},
  );

  const userSettings = {
    'apiToken': 'atlassian_token',
    'tokenType': 'oauth',
    'cloudId': 'cloud-1',
  };

  const projects = [
    JiraProject(key: 'DAB', name: 'DAB'),
    JiraProject(key: 'OPS', name: 'Ops'),
    JiraProject(key: 'SKIP', name: 'Skip'),
  ];

  setUpAll(() {
    registerFallbackValue(jiraConfig);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    resolver = FakeCredentialResolver({'user-1': userSettings});
    oauth = FakeOauthCredentialRefresher({'user-1': userSettings});
    catalog = _MockCatalog();
    configs = _MockConfigs();
    getWatch = GetJiraProjectWatchList(resolver, catalog, configs, oauth);
    saveWatch = SaveJiraProjectWatchList(getWatch, configs, resolver);
    when(() => configs.getConfigs()).thenAnswer((_) async => Right([jiraConfig]));
    when(
      () => catalog.listAccessible(
        settings: any(named: 'settings'),
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer((_) async => const Right(projects));
  });

  test('requires a connected Jira credential', () async {
    final result = await getWatch.execute('nobody');
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test('returns accessible projects and selected watch keys', () async {
    final result = await getWatch.execute('user-1');
    final watch = result.getOrElse((l) => throw StateError(l.message));
    expect(watch.selected, ['DAB', 'OPS']);
    expect(
      watch.available.map((p) => p.key),
      containsAll(['DAB', 'OPS', 'SKIP']),
    );
    expect(oauth.calls, 1);
  });

  test('retries catalog after an unauthorized response', () async {
    var calls = 0;
    when(
      () => catalog.listAccessible(
        settings: any(named: 'settings'),
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer((_) async {
      calls += 1;
      if (calls == 1) {
        return const Left(ValidationFailure('HTTP 401'));
      }
      return const Right(projects);
    });

    final result = await getWatch.execute('user-1');
    expect(result.isRight(), isTrue);
    expect(oauth.forced, isTrue);
    expect(calls, 2);
  });

  test('saves only keys the caller can still see', () async {
    when(() => configs.saveConfig(any())).thenAnswer((invocation) async {
      final config = invocation.positionalArguments.first as ProviderConfig;
      return Right(config);
    });

    final result = await saveWatch.execute(
      userId: 'user-1',
      projectKeys: ['DAB', 'UNKNOWN', 'skip-me'],
    );
    final watch = result.getOrElse((l) => throw StateError(l.message));
    expect(watch.selected, ['DAB']);

    final saved = verify(() => configs.saveConfig(captureAny())).captured.single
        as ProviderConfig;
    expect(saved.settings['projectKeys'], 'DAB');
    expect(saved.isActive, isTrue);
  });
}
