import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/figma/figma_follow_candidate_catalog.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockJsonRest extends Mock implements JsonRestProtocol {}

void main() {
  late _MockConfigs configs;
  late _MockJsonRest jsonRest;
  late FigmaFollowCandidateCatalog catalog;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.figma.com'));
  });

  setUp(() {
    configs = _MockConfigs();
    jsonRest = _MockJsonRest();
    catalog = FigmaFollowCandidateCatalog(
      configs,
      FakeCredentialResolver({
        'u-alice': {'api.token': 'figma-oauth'},
      }),
      jsonRest,
    );
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'figma',
          name: 'Figma',
          baseUrl: 'https://www.figma.com',
          isActive: true,
          settings: const {},
        ),
      ]),
    );
  });

  test('pasted file URL becomes a Follow candidate without team listing', () async {
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => {'name': 'Onboarding'},
    );

    final result = await catalog.list(
      userId: 'u-alice',
      query: 'https://www.figma.com/design/Abc12345Key/Onboarding',
    );

    final rows = result.getOrElse((_) => const []);
    expect(rows, hasLength(1));
    expect(rows.single.objectKey, 'Abc12345Key');
    expect(rows.single.title, 'Onboarding');
    expect(rows.single.kind, 'file');
  });

  test('Follow candidate title uses [folder_name] name from nested meta', () async {
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => {
        'file': {
          'name': 'DAB',
          'folder_name': 'dajo. Plugin',
        },
      },
    );

    final result = await catalog.list(
      userId: 'u-alice',
      query: 'https://www.figma.com/design/Abc12345Key/DAB',
    );

    final rows = result.getOrElse((_) => const []);
    expect(rows.single.title, '[dajo. Plugin] DAB');
  });
}
