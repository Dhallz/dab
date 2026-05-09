import 'package:dab_api/src/application/usecases/metadata/get_provider_metadata.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/provider/provider_metadata.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_metadata_repository.dart';
import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MetaRepo extends Mock implements AbsIProviderMetadataRepository {}

class _ConfigRepo extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late _MetaRepo metaRepo;
  late _ConfigRepo configRepo;
  late GetProviderMetadata useCase;

  setUp(() {
    metaRepo = _MetaRepo();
    configRepo = _ConfigRepo();
    useCase = GetProviderMetadata(metaRepo, configRepo);
  });

  test('drops metadata for inactive providers', () async {
    when(() => metaRepo.getMetadata('uid')).thenAnswer(
      (_) async => Right([
        const ProviderMetadata(
          id: 'a',
          name: 'A',
          provider: 'slack',
          type: 'message',
        ),
        const ProviderMetadata(
          id: 'b',
          name: 'B',
          provider: 'phorge',
          type: 'tag',
        ),
      ]),
    );
    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://slack.com',
          isActive: false,
          iconUrl: '',
          settings: {},
        ),
        ProviderConfig(
          id: 'phorge',
          name: 'Phorge',
          baseUrl: 'https://p',
          isActive: true,
          iconUrl: '',
          settings: {},
        ),
      ]),
    );

    final out = await useCase.execute('uid');
    expect(out.isRight(), true);
    final list = out.getRight().toNullable()!;
    expect(list.length, 1);
    expect(list.single.provider.toLowerCase(), 'phorge');
  });
}
