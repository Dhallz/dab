import 'package:dab_api/src/application/usecases/user/get_linear_team_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/save_linear_team_watch_list.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/linear_team.dart';
import 'package:dab_api/src/domain/ports/i_linear_team_catalog.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import '../../../fakes/fake_credential_resolver.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCatalog extends Mock implements ILinearTeamCatalog {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late FakeCredentialResolver resolver;
  late _MockCatalog catalog;
  late _MockConfigs configs;
  late GetLinearTeamWatchList getWatch;
  late SaveLinearTeamWatchList saveWatch;

  final linearConfig = ProviderConfig(
    id: 'linear',
    name: 'Linear',
    baseUrl: 'https://linear.app',
    isActive: true,
    settings: const {'teamKeys': 'ENG\nOPS'},
  );

  const teams = [
    LinearTeam(key: 'ENG', name: 'Engineering'),
    LinearTeam(key: 'OPS', name: 'Ops'),
    LinearTeam(key: 'SKIP', name: 'Skip'),
  ];

  setUpAll(() {
    registerFallbackValue(linearConfig);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    resolver = FakeCredentialResolver({
      'user-1': {'apiKey': 'lin_oauth', 'tokenType': 'oauth'},
    });
    catalog = _MockCatalog();
    configs = _MockConfigs();
    getWatch = GetLinearTeamWatchList(resolver, catalog, configs);
    saveWatch = SaveLinearTeamWatchList(resolver, catalog, configs);
    when(
      () => configs.getConfigs(),
    ).thenAnswer((_) async => Right([linearConfig]));
    when(
      () => catalog.listAccessible(
        settings: any(named: 'settings'),
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer((_) async => const Right(teams));
  });

  test('requires a connected Linear credential', () async {
    final result = await getWatch.execute('nobody');
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test('returns accessible teams and selected watch keys', () async {
    final result = await getWatch.execute('user-1');
    final watch = result.getOrElse((l) => throw StateError(l.message));
    expect(watch.selected, ['ENG', 'OPS']);
    expect(
      watch.available.map((t) => t.key),
      containsAll(['ENG', 'OPS', 'SKIP']),
    );
  });

  test('saves only keys the caller can still see', () async {
    when(() => configs.saveConfig(any())).thenAnswer((invocation) async {
      final config = invocation.positionalArguments.first as ProviderConfig;
      return Right(config);
    });

    final result = await saveWatch.execute(
      userId: 'user-1',
      teamKeys: ['ENG', 'UNKNOWN', 'skip-me'],
    );
    final watch = result.getOrElse((l) => throw StateError(l.message));
    expect(watch.selected, ['ENG']);

    final saved =
        verify(() => configs.saveConfig(captureAny())).captured.single
            as ProviderConfig;
    expect(saved.settings['teamKeys'], 'ENG');
    expect(saved.isActive, isTrue);
  });
}
